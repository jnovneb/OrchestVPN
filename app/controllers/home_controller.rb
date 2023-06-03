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
    #Contraseña para ejecutar con sudo
    password = "javier y pepo"
    #Guardas nombre vpn y luego la ruta del archivo de configuración
    nombre = @vpn.name
    ruta = Rails.root.join('vpn_files', "#{nombre}", "#{nombre}.ovpn").to_s
    command2 = "#{Rails.root}/vendor/sh/Prueba.sh #{nombre} #{ruta}"
    system(command2)
    ruta = Rails.root.join('vpn_files', "#{nombre}", "#{nombre}.ovpn").to_s
    #Llamar al script de Bash con los argumentos recopilados
    command = "echo '#{password}' | sudo -E -S #{Rails.root}/vendor/sh/ConnectClient.sh #{ruta}"
    system(command)
  end
end