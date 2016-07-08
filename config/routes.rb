Rails.application.routes.draw do

  devise_for :users
  
  root 'static_pages#home'
  get  'static_pages/help'
  get  'static_pages/about'
  get  'static_pages/contact'

  resources   :items do
    resources :comments
  end

end
