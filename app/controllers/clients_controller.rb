class ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy ]

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
    vpn = @client.vpn
    name = @client.name
    ruta = Rails.root.join('vpn_files', vpn).to_s
    password = 'javier y pepo'



    if @client.encrypted_password.present?
      contrasena = @client.encrypted_password
    else
      contrasena = nil
    end
    
    command = "echo '#{password}' | sudo -E -S #{Rails.root}/vendor/sh/newClient.sh #{ruta} #{name} #{contrasena}"
    system(command)


    rt = Rails.root.join('vpn_files', vpn, name+".ovpn")

    archivo = File.read(rt)
    config= archivo.match(/.*(?=<ca>)/m).to_s
    cert = archivo.scan(/<cert>(.*?)<\/cert>/m).flatten.first

    @client.update_attribute(:cert, cert)
    
    @client.update_attribute(:options, config)


    respond_to do |format|
      if @client.save
        format.html { redirect_to client_url(@client), notice: "Client was successfully created." }
        format.json { render :show, status: :created, location: @client }
      else
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

    password = "javier y pepo"
    nombre = @client.name
    ruta = Rails.root.join('vpn_files').to_s
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
      params.require(:client).permit(:vpn, :name, :desc, :cert, :options)
    end
end
