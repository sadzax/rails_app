Rails.application.routes.draw do
  resources :users
  resources :orders
  resources :vms
  get 'hello/index'
  mount GrapeAPI => '/api’
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end