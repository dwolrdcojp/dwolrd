Rails.application.routes.draw do
  root 'home#index'

  resources   :items do
    resources :comments
  end

end
