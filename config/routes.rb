Rails.application.routes.draw do
  resources :groups
  resources :users
  resources :orders
  resources :vms
  get 'hello/index'
  mount GrapeApi => '/api'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end