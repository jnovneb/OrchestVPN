class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :set_selected_user, only: [:move_to_admins, :move_to_non_admins]

  # GET /users or /users.json
  def index
    @user = User.new
    @non_admins = User.where(admin: false)
    @admins = User.where(admin: true)
    @selected_user = User.find(params[:selected_user_id]) if params[:selected_user_id].present?
    @users = User.all
    @selected_user_id = params[:selected_user_id]
  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def move_to_admins
    @user = User.find(params[:id])
    @user.update(admin: true)
    redirect_to users_path
  end

  def move_to_non_admins
    @user = User.find(params[:id])
    @user.update(admin: false)
    redirect_to users_path
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def addusersvpn
    selected_vpn_id = params[:user][:vpn_id]
    user_ids = params[:user][:user_add_ids]

    puts selected_vpn_id
    puts user_ids
    user_ids.each do |other_user_id|
      if UsersVpn.exists?(user_id: other_user_id, vpn_id: selected_vpn_id)
        user = User.find(other_user_id)
        flash.now[:error] = "User #{user.email} already has a relation with the selected VPN."
      else
        UsersVpn.create(user_id: other_user_id, vpn_id: selected_vpn_id)
      end
    end
    flash.now[:success] = 'Users added correctly.'
    redirect_to users_path
  end

  def delusersvpn
    selected_vpn_id = params[:user][:vpn_id]
    user_deleted = params[:user][:user_del_ids]

    puts selected_vpn_id
    puts user_deleted

    user_deleted.each do |other_user_id|
      if UsersVpn.exists?(user_id: other_user_id, vpn_id: selected_vpn_id)
        user = User.find(other_user_id)
        puts "BORRAUUUUUUUU"
        UsersVpn.find_by(user_id: other_user_id, vpn_id: selected_vpn_id).destroy
        flash.now[:success] = "User #{user.email} delete from VPN."
      else
        puts "No Borrau"
      end
    end
  end

  def options
    selected_vpn_id = params[:vpn_id]
    users_without_vpn = User.where.not(id: UsersVpn.where(vpn_id: selected_vpn_id).pluck(:user_id)).pluck(:email, :id)
  
    # Renderizar las opciones de usuario como un arreglo de arreglos en formato JSON
    render json: options_for_select(users_without_vpn).to_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
    def set_selected_user
      @selected_user = User.find_by(id: params[:selected_user_id])
    end
end
