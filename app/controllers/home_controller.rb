class HomeController < ApplicationController


#  before_action :authenticate_admin!, only: [:action] # `only` part if applicable

  def index
    if current_user.admin
      @vpns = Vpn.all
    else
      @user_vpns = current_user.vpns
    end
  end

  def show
    @vpn = Vpn.find(params[:id])
  end

  def settings
    #Aquí llamarás a la página donde se muestren los ajustes
  end

  def monitor
    #Aquí llamarás a la página donde se muestre la monitorización
  end

  def connect
    vpn_id = params[:vpn_id]
    @vpn = Vpn.find(vpn_id)
    # Guarda el nombre de la VPN y luego la ruta del archivo de configuración
    nombre = @vpn.name
    ruta = Rails.root.join('vpn_files', "#{nombre}", "#{nombre}.ovpn").to_s
    # Envía el archivo como descarga adjunta
    send_file(ruta, disposition: 'attachment', filename: "#{nombre}.ovpn")
    
    flash[:notice] = "Archivo descargado exitosamente"
    redirect_to root_path
  end
end