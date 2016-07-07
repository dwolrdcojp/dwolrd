Rails.application.routes.draw do
  
  resources   :items do
    resources :comments
  end

  get  'home/index'
  root 'home#index'
end
