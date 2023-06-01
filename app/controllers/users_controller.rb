class UsersController < ApplicationController
    before_action :set_selected_user, only: [:move_to_admins, :move_to_non_admins]
    def index
        @non_admins = User.where(admin: false)
        @admins = User.where(admin: true)
        @selected_user = User.find(params[:selected_user_id]) if params[:selected_user_id].present?
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
      
    private
  
    def set_selected_user
      @selected_user = User.find_by(id: params[:user_id])
    end
  end
  