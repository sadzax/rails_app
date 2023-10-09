require 'httpclient'
require 'json'

class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]

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

  def check
    before_action :authenticate_user!
    #  Получить пользователя этого заказа
    possible_orders_url = 'http://possible_orders.srv.w55.ru/'
    possible_orders_data = process_possible_orders(possible_orders_url)
    if order_is_valid?(params, possible_orders_data)
      status = 'ok'
      result = true
      render json: { message: 'Параметры заказа получены' }
    else
      ## Rescue? 
      status = '406'
      result = false
      render json: { message: 'Некорректные параметры заказа' }
    #  Запросить цену машины
    #  Запросить баланс пользователя
    main_response 
  end

  private
  def order_is_valid?(order_params, possible_orders_data)
    return false unless order_params['cpu'].to_i.to_s == order_params['cpu']
    return false unless order_params['ram'].to_i.to_s == order_params['ram']
    return false unless order_params['hdd_capacity'].to_i.to_s == order_params['hdd_capacity']
    ## Прописать
    return false unless %w[sata sas ssd].include?(order_params['hdd_type'])
    return false unless %w[windows linux].include?(order_params['os'])
    ## Временная заглушка
    true
  end

  def process_possible_orders(url)
    client = HTTPClient.new
    get_response = client.request(:get, url)
    JSON.parse(get_response)
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
