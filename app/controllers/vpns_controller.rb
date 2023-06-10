class VpnsController < ApplicationController
  before_action :set_vpn, only: %i[ show edit update destroy ]
  

  # GET /vpns or /vpns.json
  def index
    if current_user.admin
      @vpns = Vpn.all
    else
      @vpns = current_user.users_vpns.where(admin_vpn: true).map(&:vpn)
    end
  end
  

  # GET /vpns/1 or /vpns/1.json
  def show
  end

  # GET /vpns/new
  def new
    @vpn = Vpn.new
  end

  # GET /vpns/1/edit
  def edit
  end

  # POST /vpns or /vpns.json
  def create
    # Verificar y asignar usuarios seleccionados
    user_ids = params[:vpn][:users].reject(&:empty?) if params[:vpn][:users]
    users = User.where(id: user_ids)
    params[:vpn][:users] = users if users.present?

    cidr = params[:vpn][:CIDR]
    
    # Verificar y asignar administradores seleccionados
    admin_ids = params[:vpn][:vpn_admin_list].reject(&:empty?) if params[:vpn][:vpn_admin_list]
    admins = User.where(id: admin_ids)
    params[:vpn][:vpn_admin_list] = admins if admins.present?


    @vpn = Vpn.new(vpn_params)
    #Esto es solo para probar
    password = "javier y pepo"


    @vpn.server = Server.find(params[:vpn][:server_id])
    server_id = params[:vpn][:server_id]
    @vpn.server_id = server_id

    respond_to do |format|
      admin_ids = params[:vpn][:vpn_admin_list].is_a?(Array) ? params[:vpn][:vpn_admin_list].reject(&:empty?) : []
      admins = User.where(id: admin_ids)
      params[:vpn][:vpn_admin_list] = admins if admins.present?
      if @vpn.save
        ruta = Rails.root.join('vpn_files').to_s
        ip_servidor = @vpn.server
        if server_id.present?
          server = Server.find_by(id: server_id)
          ip_servidor = server.addr if server
        end
        puerto_servidor = @vpn.port
        cliente = @vpn.name
        ancho_banda = @vpn.bandwidth.present? ? @vpn.bandwidth : nil

        # Llamar al script de Bash con los argumentos recopilados
        command = "echo '#{password}' | sudo -E -S #{Rails.root}/vendor/sh/newVPN.sh #{ruta} #{cliente} #{puerto_servidor} #{ancho_banda}"
        system(command)
        # Actualizar el parámetro admin_vpn para el usuario actual
        current_user_vpn = @vpn.users_vpns.find_by(user_id: current_user.id)
        current_user_vpn.update(admin_vpn: true) if current_user_vpn


        format.html { redirect_to vpn_url(@vpn), notice: "Vpn was successfully created." }
        format.json { render :show, status: :created, location: @vpn }

      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vpn.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vpns/1 or /vpns/1.json
  def update
    respond_to do |format|
      if @vpn.update(vpn_params)
        format.html { redirect_to vpn_url(@vpn), notice: "Vpn was successfully updated." }
        format.json { render :show, status: :ok, location: @vpn }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vpn.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vpns/1 or /vpns/1.json
  def destroy

    password = "javier y pepo"
    ruta = Rails.root.join('vpn_files', @vpn.name).to_s
    
    @vpns = Dir.glob(File.join(ruta, '*.ovpn')) # Obtener la lista de archivos .ovpn en el directorio
    
    @vpns.each do |archivo|
      nombre = File.basename(archivo, '.ovpn') # Obtener el nombre del archivo sin la extensión .ovpn
    
      # Llamar al script de Bash con los argumentos recopilados
      command = "echo '#{password}' | sudo -E -S #{Rails.root}/vendor/sh/DeleteSingleClient.sh #{nombre} #{ruta}"
      system(command)
    end
    #Delete registers related in the users_vpn table
    @vpn.users_vpns.destroy_all
    @vpn.destroy

    FileUtils.rm_rf(ruta)
    
    respond_to do |format|
      format.html { redirect_to vpns_url, notice: "Vpn was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vpn
      @vpn = Vpn.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vpn_params
      params.require(:vpn).permit(:name, :description, :port, :server_id, :bandwidth, user_ids: [], vpn_admin_list: [])
    end

end
