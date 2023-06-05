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
    begin
      # Guarda el nombre de la VPN y luego la ruta del archivo de configuración
      nombre = Vpn.find(vpn_id).name
      ruta = Rails.root.join('vpn_files', "#{nombre}", "#{nombre}.ovpn").to_s
      # Verifica si el archivo existe antes de enviarlo como descarga adjunta
      if File.exist?(ruta)
        # Envía el archivo como descarga adjunta
        send_file(ruta, disposition: 'attachment', filename: "#{nombre}.ovpn")
        flash[:notice] = "Archivo descargado exitosamente"
      else
        flash[:error] = "El archivo de configuración no existe"
      end
      redirect_to root_path
  end 
end