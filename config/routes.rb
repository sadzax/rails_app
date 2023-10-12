Rails.application.routes.draw do
  resources :groups
  resources :users
  resources :orders
  resources :vms
  get 'hello/index'
  mount GrapeApi => '/api'
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
