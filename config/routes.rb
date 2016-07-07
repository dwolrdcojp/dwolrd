Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  resources   :items do
    resources :comments
  end

end
