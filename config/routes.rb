Rails.application.routes.draw do
  get 'static_pages/home'

  get 'static_pages/help'

  devise_for :users
  root 'home#index'

  resources   :items do
    resources :comments
  end

end
