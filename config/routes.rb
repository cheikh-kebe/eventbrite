Rails.application.routes.draw do
  
  devise_for :users
  root 'events#index'
  
  resources :events do
    resources :attendances
  end
  
  resources :users

  namespace :admin do
    resources :users
    root 'admin/users#index'
  end
  
end
