require 'httpclient'
require 'json'
require 'uri'

Rails.application.routes.draw do
  resources :groups
  resources :users
  get 'orders/check', controller: :orders
  resources :orders
  resources :vms
  mount Sidekiq::Web => '/sidekiq'

  # get '/calc' do
  #   costcalc_uri = URI.parse('http://costcalc:5678/calc')

  #   # Параметры запроса по умолчанию
  #   query_params = { cpu: 2, ram: 8, hdd_type: 'ssd', hdd_capacity: 512 }

  #   # Преобразование параметров запроса
  #   url_with_params = "http://costcalc:5678/calc?#{URI.encode_www_form(query_params)}"
  #   client = HTTPClient.new
  #   response = client.get(url_with_params)
  # end

  get 'hello/index'
  mount GrapeApi => '/api'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :reports, only: [:create]
  end

end