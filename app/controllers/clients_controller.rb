class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy ]
  @password = Rails.application.credentials.sudo_pass

  # GET /clients or /clients.json
  def index
    @clients = Client.all
  end

  # GET /clients/1 or /clients/1.json
  def show
  end

  # GET /clients/new
  def new
    @client = Client.new
    @vpn_name = params[:vpn_name]
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients or /clients.json
  def create

    @client = Client.new(client_params)

    @client.vpn_id = Vpn.find_by(name: @client.vpnName)&.id

    servername = @client.vpn.server.name
    vpnName = @client.vpn.name
    name = @client.name

    file = Rails.root.join('vpn_files', servername, vpnName, "#{vpnName}.conf")
    cidr = obtener_direccion_ip_from_archivo(file)
    clientaddr = calculate_IP_in(cidr)
    clientaddrout = calculate_IP_out(cidr)
 

    ruta = Rails.root.join('vpn_files', servername,vpnName, 'Clients').to_s

    if @client.encrypted_password.present?
      contrasena = @client.encrypted_password
    else
      contrasena = nil
    end

    command = "echo '#{@password}' | sudo -E -S #{Rails.root}/vendor/sh/newClient.sh #{ruta} #{name} #{vpnName} #{clientaddr} #{clientaddrout}#{contrasena} "
    system(command)

    rt = Rails.root.join('vpn_files', servername, vpnName, 'Clients', "#{name}.ovpn")

    archi = File.read(rt)
    config= archi.match(/.*(?=<ca>)/m).to_s

    cert = archi.scan(/<cert>(.*?)<\/cert>/m).flatten.first
    @client.update(cert: cert)
    
    @client.update(options: config)

    rt2 = Rails.root.join('vpn_files', servername, vpnName, 'Clients', name+".ovpn")

    respond_to do |format|
      if @client.save

        # Adjuntar archivo al modelo Client
        file = File.open(rt2)
        puts rt2
        puts @client.file.name
        @client.file.attach(io: file, filename: "#{name}.ovpn")
        format.html { redirect_to client_url(@client), notice: "Client was successfully created." }
        format.json { render :show, status: :created, location: @client }
      else
        puts "Dentro else"
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to client_url(@client), notice: "Client was successfully updated." }
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    servername = @client.vpn.server.name
    vpnName = @client.vpnName

    password = "javier y pepo"
    nombre = @client.name
    ruta = Rails.root.join('vpn_files', servername, vpnName, 'Clients').to_s
    #Llamar al script de Bash con los argumentos recopilados
    command = "echo '#{password}' | sudo -E -S #{Rails.root}/vendor/sh/DeleteSingleClient.sh #{nombre} #{ruta}"
    system(command)
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url, notice: "Client was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(:vpnName, :name, :desc, :cert, :options, :vpn_id)
    end

    def calculate_IP_in(cidr)
      #Get the number of clients associated to the VPN
      if @client.vpn.clients.count == 0
        #If we dont have clients yet, numberClients=1(The one that we are creating)
        numberClients = @client.vpn.clients.count + 1
      else
        #numberClients will be 2, because we use 2 IP for each client
        numberClients = @client.vpn.clients.count + 2
      end
      puts numberClients
      #Split IP
      octetos = cidr.split('.')
      #Replace last one with the numberClients value
      octetos[3] = numberClients

      #Join to form new IP
      nueva_ip = octetos.join('.')
      puts nueva_ip
      return nueva_ip
    end

    def calculate_IP_out(cidr)
      #Get the number of clients associated to the VPN
      numberClients = @client.vpn.clients.count + 2
      puts numberClients
      #Split IP
      octetos = cidr.split('.')
      #Replace last one with the numberClients value
      octetos[3] = numberClients

      #Join to form new IP
      nueva_ip = octetos.join('.')
      puts nueva_ip
      return nueva_ip
    end

    def obtener_direccion_ip_from_archivo(archivo)
      # Read file content
      contenido = File.read(archivo)
      # Search server line
      linea_server = contenido.lines.find { |linea| linea.include?("server") }
      # Get the IP
      direccion_ip = linea_server.split(" ")[1]
      return direccion_ip
    end
end
