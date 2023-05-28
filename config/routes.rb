Rails.application.routes.draw do
  devise_for :users
  resources :vpns
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'

  get '/home', to: 'home#index', as: 'home'
  post '/home', to: 'home#connect', as: 'connect'
  get '/contact', to: 'contact#index', as: 'contact'
  get '/settings', to: 'settings#index', as: 'settings'
  get '/monitoring', to: 'monitoring#index', as: 'monitoring'
  get '/ejecutar', to:'ejecutar#index', as:'ejecutar'
  get '/users', to: 'users#index', as:'users'
end
