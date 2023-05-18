class HomeController < ApplicationController


#  before_action :authenticate_admin!, only: [:action] # `only` part if applicable

  def index
    @vpns = Vpn.all
  end

  def show
    @vpn = Vpn.find(params[:id])
  end

  def settings
    #Aquí llamarás a la página donde se muestren los ajustes
  end

  def monitore
    #Aquí llamarás a la página donde se muestre la monitorización
  end
end