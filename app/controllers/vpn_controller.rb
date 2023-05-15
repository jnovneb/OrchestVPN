class VpnController < ApplicationController
  before_action :authenticate_user!
  def index
    render
  end

  def new
    @vpn = VPN.new
  end

  # Agrega la acción 'create' para manejar el envío del formulario
  def create
    @vpn = VPN.new(vpn_params)
    if @vpn.save
      redirect_to @vpn, notice: 'VPN creada exitosamente.'
    else
      render :new
    end
  end

  private

  def vpn_params
    params.require(:vpn).permit(:name, :servidor, :port, )
  end
end
