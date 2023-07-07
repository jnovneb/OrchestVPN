class ServersController < ApplicationController
  before_action :set_server, only: %i[show edit update destroy]
  @password = Rails.application.credentials.sudo_pass

  # GET /servers or /servers.json
  def index
    @servers = Server.all
  end

  # GET /servers/1 or /servers/1.json
  def show
  end

  # GET /servers/new
  def new
    @server = Server.new
  end

  # GET /servers/1/edit
  def edit
  end

  # POST /servers or /servers.json
  def create
    name = params[:server][:name]
    cert = params[:server][:CAcert]
    key = params[:server][:CAkey]


    @server = Server.new(server_params)
    @server.name = name
    @server.CAcert = cert
    @server.CAkey = key 

    respond_to do |format|
      if @server.save
        format.html { redirect_to server_url(@server), notice: "Server was successfully created." }
        format.json { render :show, status: :created, location: @server }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servers/1 or /servers/1.json
  def update
    respond_to do |format|
      if @server.update(server_params)
        format.html { redirect_to server_url(@server), notice: "Server was successfully updated." }
        format.json { render :show, status: :ok, location: @server }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    sername = @server.name
    ruta = Rails.root.join('vpn_files', "#{sername}").to_s
  
    ActiveRecord::Base.transaction do
      @server.vpns.find_each do |vpn|
        vpnname = vpn.name
        vpn_id = vpn.id
        vpn.clients.find_each do |client|
          name = client.name
          path = Rails.root.join('vpn_files', sername, 'VPNs', vpnname).to_s
          command = "echo '#{@password}' | sudo -E -S #{Rails.root}/vendor/sh/DeleteSingleClient.sh #{name} #{path}"
          system(command)
          client.destroy
        end
        path2 = Rails.root.join('vpn_files', sername, 'VPNs', vpnname).to_s
        FileUtils.rm_rf(path2)
        UsersVpn.where(vpn_id: vpn_id).destroy_all
        vpn.destroy!
      end
      @server.destroy!
  
      command = "echo '#{@password}' | sudo -E -S #{Rails.root}/vendor/sh/DeleteSingleServer.sh #{sername} #{ruta}"
      system(command)
    end
  
    respond_to do |format|
      format.html { redirect_to servers_url, notice: "Server was successfully destroyed." }
      format.json { head :no_content }
    end
  rescue ActiveRecord::RecordNotDestroyed => e
    error_message = "Failed to destroy the server. Reason: #{e.record.errors.full_messages.to_sentence}"
    respond_to do |format|
      format.html { redirect_to servers_url, alert: error_message }
      format.json { render json: { error: error_message }, status: :unprocessable_entity }
    end
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = Server.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def server_params
      params.require(:server).permit(:name, :CAcert, :CAkey)
    end



end
