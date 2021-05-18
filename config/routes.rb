Rails.application.routes.draw do

  root 'events#index'
  
  devise_for :users
  resources :attendances
  resources :events
  resources :users
  
end
