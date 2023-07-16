Rails.application.routes.draw do
  resources :clients
  resources :servers
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
  delete '/users', to: 'users#destroy', as: 'delete_users'

  post 'addusersvpn', to: 'users#addusersvpn', as: 'addusersvpn'

  post '/delusersvpn', to: 'users#delusersvpn', as: 'delusersvpn'

  get '/users/options', to: 'users#options', as: 'options'

  resources :users do
    member do
      patch :move_to_admins
      patch :move_to_non_admins
      post :add_user_to_vpn
      post :delete_user_from_vpn
    end
    delete :destroy, on: :collection
  end
end
