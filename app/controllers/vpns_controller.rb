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
    
    # Verificar y asignar administradores seleccionados
    admin_ids = params[:vpn][:vpn_admin_list].reject(&:empty?) if params[:vpn][:vpn_admin_list]
    admins = User.where(id: admin_ids)
    params[:vpn][:vpn_admin_list] = admins if admins.present?


    @vpn = Vpn.new(vpn_params)
    #Esto es solo para probar
    password = "javier y pepo"

    respond_to do |format|
      admin_ids = params[:vpn][:vpn_admin_list].is_a?(Array) ? params[:vpn][:vpn_admin_list].reject(&:empty?) : []
      admins = User.where(id: admin_ids)
      params[:vpn][:vpn_admin_list] = admins if admins.present?
      if @vpn.save
        ruta = Rails.root.join('vpn_files').to_s
        ip_servidor = @vpn.server
        puerto_servidor = @vpn.port
        cliente = @vpn.name
        ancho_banda = @vpn.bandwidth.present? ? @vpn.bandwidth : nil
        contrasena = @vpn.encrypted_password.present? ? @vpn.bandwidth : nil
        # Llamar al script de Bash con los argumentos recopilados
        command = "echo '#{password}' | sudo -E -S #{Rails.root}/vendor/sh/NewClient3.sh #{ruta} #{cliente} #{ip_servidor} #{puerto_servidor} #{ancho_banda} #{contrasena}"
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
    nombre = @vpn.name
    ruta = Rails.root.join('vpn_files').to_s
    #Llamar al script de Bash con los argumentos recopilados
    command = "echo '#{password}' | sudo -E -S #{Rails.root}/vendor/sh/DeleteSingleClient.sh #{nombre} #{ruta}"
    system(command)
    @vpn.destroy

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
    def vpn_params_old
      params.fetch(:vpn, {})
    end
    def vpn_params
      params.require(:vpn).permit(:name, :description, :encrypted_password, :port, :server, :bandwidth, user_ids: [], vpn_admin_list: [])
    end

    

end
