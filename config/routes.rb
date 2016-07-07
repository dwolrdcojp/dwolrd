Rails.application.routes.draw do
  resources :items
  get 'home/index'

  root 'home#index'
end
