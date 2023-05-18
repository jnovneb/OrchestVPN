

class VpnController < ApplicationController
  before_action :authenticate_user!
  def index
    render
  end

  def new
    @vpn = Vpn.new
  end

  def show
    @vpn = Vpn.find(params[:id])
  end

  # Agrega la acción 'create' para manejar el envío del formulario
  def create
    puts params.inspect
    @vpn = Vpn.new(vpn_params)
    if @vpn.save
     redirect_to @vpn, notice: 'VPN creada exitosamente.'
    else
     render :new
    end
  end

  private

  def vpn_params
    params.require(:vpn).permit(:name, :description)
  end
end
