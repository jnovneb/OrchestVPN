Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'home#index'

  get '/home', to: 'home#index', as: 'home'

  get '/vpn', to: 'vpn#index', as: 'vpn'
  get '/contact', to: 'contact#index', as: 'contact'

end
