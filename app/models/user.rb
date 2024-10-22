class User < ApplicationRecord
  has_many :users_vpns
  has_many :vpns, through: :users_vpns
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_destroy :cleanup_users_vpns

  def authenticate_admin!
    authenticate_user!
    redirect_to :somewhere, status: :forbidden unless current_user.admin?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !!current_user
  end

  def is_admin?
    signed_in? ? current_user.admin : false
  end

  def is_vpnadmin?
    signed_in? ? current_user.admin_vpn : false
  end

  private

  def cleanup_users_vpns
    users_vpns.destroy_all
  end
end
