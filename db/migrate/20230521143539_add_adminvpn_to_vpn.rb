class AddAdminvpnToVpn < ActiveRecord::Migration[7.0]
  def change
    add_column :vpns, :vpn_admin_list, :string
  end
end
