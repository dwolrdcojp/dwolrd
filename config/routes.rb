Rails.application.routes.draw do

  get 'transactions/new'

  root 'items#index'
  
  get '/about',   to: 'static_pages#about'
  get '/garage',  to: 'items#garage'
  get 'sales'     => "orders#sales"
  get 'purchases' => "orders#purchases"

  devise_for :users

  resources   :items do
    resources :orders, only: [:new, :create]
    resources :comments
    put :favorite, on: :member
  end

  resources :conversations do
    resources :messages
  end

  resources :transactions, only: [:new, :create]
  
end
