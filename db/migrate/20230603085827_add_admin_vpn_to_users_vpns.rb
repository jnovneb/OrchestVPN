class AddAdminVpnToUsersVpns < ActiveRecord::Migration[7.0]
  def change
    add_column :users_vpns, :admin_vpn, :boolean, default: false
  end
end
