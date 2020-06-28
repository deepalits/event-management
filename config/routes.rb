Rails.application.routes.draw do
  root 'events#index'
  resources :users
  resources :events
  resources :user_events, only: %i[index]
end
