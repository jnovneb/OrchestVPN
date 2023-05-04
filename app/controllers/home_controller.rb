class HomeController < ApplicationController


#  before_action :authenticate_admin!, only: [:action] # `only` part if applicable

  def index
    render
  end
  def show_vpn
    # Primero crea el modelo de las VPN, crea alguna de ejemplo y consigue que se inserte en la BBDD
    # Crea un botón por cada VPN que haya, en los folios y en el git tienes un ejemplo de como se hace
  end
end