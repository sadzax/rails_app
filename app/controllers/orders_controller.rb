require 'httpclient'
require 'json'
require 'uri'

class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:check]
  before_action :set_user, only: [:check]

  # GET /orders or /orders.json
  def index
    # @orders = []
    #   Order.includes(:networks).each do |order|
    #     @orders << {
    #       name: order.name,
    #       created_at: order.created_at,
    #       networks_count: order.networks.size
    #     }
    #     end
    page = params[:page].present? ? params[:page].to_i : 1
    per_page = params[:per_page].present? ? params[:per_page].to_i : 30
    @orders = Order.limit(per_page).offset((page-1) * per_page).order('id ASC') # нужно умножить
    # @orders = Order.all  # init
    # render json: { orders: @orders }
    # # render json: { orders: @orders.select(:name, :networks) }  # okay!
  end 

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1 or /orders/1.json

  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  DEFAULT_COST_SERVICE = 'http://costcalc:5678/calc'  # Не localhost?
  def check(cost_service = DEFAULT_COST_SERVICE, attr)
    
    user = @user

    possible_configs = parse_possible_configs  # Можно передать другой конфиг, если указать аргумент

    #  Проверка конфигурации на 406 ошибку
    unless possible_config?(possible_configs, attr)
      render json: { result: false, error: 'Not Acceptable' }, status: :not_acceptable
      return
    end

      # MASK = {cpu, ram, hdd_type, hdd_capacity}  
      # url tail example:  /calc?cpu=2&ram=27&hdd_type=sata&hdd_capacity=233333232
      #  Считает конфигурацию
      url_with_params = "#{cost_service}?#{URI.encode_www_form(attr)}"
      client = HTTPClient.new
      response_of_the_service = client.get(url_with_params)

      #  Проверка сервиса на 503 ошибку
      if response_of_the_service.status != 200
        render json: { result: false, error: 'Service Unavailable' }, status: :service_unavailable
        return
      end

      result_calc_data = JSON.parse(response_of_the_service.body)
      cost_of_new_order = result_calc_data['result']
      balance_after_transaction = user.balance - cost_of_new_order
      unless balance_after_transaction < 0
        render json: { result: false, error: 'Not Acceptable' }, status: :not_acceptable
        return
      end

      render json: {
        result: true,
        total: cost_of_new_order,
        balance: user.balance,
        balance_after_transaction: balance_after_transaction
      }

    #  Проверка сервиса на 503 ошибку
    rescue StandartError => each
      render json:  { result: false, error: 'Service Unavailable' }, status: :service_unavailable

  end
  
  private
  def set_user(user_id)
    @user  = User.find_by(id: user_id)
    #  Проверка пользователя на 401 ошибку
    if user.nil? || params[:balance].nil?
      render json: { error: 'Unauthorized' }, status: :unauthorized
      return
    end
  end

  def parse_possible_configs(url = 'http://possible_orders.srv.w55.ru/')
    client = HTTPClient.new
    get_response = client.request(:get, url)
    JSON.parse(get_response.body)
  end

  def possible_config?(possible_configs, params)
    status = false  # По умолчанию у нас условие соответствия конфигурации не выполнено
    possible_configs["specs"].each do |configuration|
      if params[:os] == configuration["os"][0] &&
        configuration["cpu"].include?(params[:cpu].to_i.to_s) &&
        configuration["ram"].include?(params[:ram].to_i.to_s) &&
        configuration["hdd_type"].include?(params[:hdd_type]) &&
        params[:hdd_capacity].between?(configuration["hdd_capacity"][params[:hdd_type]]["from"], 
                                       configuration["hdd_capacity"][params[:hdd_type]]["to"])
        status = true
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(:name, :status, :cost)
  end
end