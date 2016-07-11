Rails.application.routes.draw do

  root 'items#index'
  
  get '/about',   to: 'static_pages#about'
  get '/garage',  to: 'items#garage'

  devise_for :users

  resources   :items do
    resources :comments
  end

  resources :conversations do
    resources :messages
  end
  
end
