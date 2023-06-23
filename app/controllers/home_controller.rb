class HomeController < ApplicationController


#  before_action :authenticate_admin!, only: [:action] # `only` part if applicable

  def index
    if current_user.admin
      @clients = Client.all
    else
      @clients_vpns = Client.where(vpn_id: current_user.vpns.pluck(:id))
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
    client_id = params[:client_id].to_i
    puts client_id
    puts "Arriba id"
    nombre = Client.find(client_id).name
    client = Client.find_by(id: client_id)
    vpn = client.vpn_id
    vpn_name = Vpn.find(vpn).name
    server = Vpn.find(vpn).server_id
    server_name = Server.find(server).name
    ruta = Rails.root.join('vpn_files', server_name, vpn_name, 'Clients',"#{nombre}.ovpn").to_s
  
    if File.exist?(ruta)
      send_data client.file.download, filename: "#{nombre}.ovpn", disposition: 'attachment'
      flash[:notice] = "Archivo descargado exitosamente"
    else
      flash[:error] = "El archivo de configuración no existe"
    end
  end
  
  
  
end