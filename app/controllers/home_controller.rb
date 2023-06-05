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
      @vpn = Vpn.find(vpn_id)
      # Guarda el nombre de la VPN y luego la ruta del archivo de configuración
      nombre = @vpn.name
      ruta = Rails.root.join('vpn_files', "#{nombre}", "#{nombre}.ovpn").to_s
      # Verifica si el archivo existe antes de enviarlo como descarga adjunta
      if File.exist?(ruta)
        # Envía el archivo como descarga adjunta
        send_file(ruta, disposition: 'attachment', filename: "#{nombre}.ovpn")
        flash[:notice] = "Archivo descargado exitosamente"
        redirect_to root_path
      else
        flash[:error] = "El archivo de configuración no existe"
        redirect_to root_path
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "VPN no encontrada"
      redirect_to root_path
    rescue => e
      flash[:error] = "Ocurrió un error al descargar el archivo de configuración: #{e.message}"
      redirect_to root_path
    end
  end 
end