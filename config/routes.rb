Rails.application.routes.draw do

  root 'items#index'
  
  get 'about',   to: 'static_pages#about'
  get 'garage',  to: 'items#garage'
  post 'paypal/ipn_notify', to: 'orders#notify'
  get 'sales'     => "orders#sales"
  get 'purchases' => "orders#purchases"
  get 'favorites' => "items#favorites"

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  get 'items/new' => 'items#new', as: :user_root

  resources   :items do
    resource :order, only: [:new, :create]
    resources :comments
    put :favorite, on: :member
  end

  resources :conversations do
    resources :messages
  end

  resources :transactions, only: [:new, :create]
  
  resources :users
end
