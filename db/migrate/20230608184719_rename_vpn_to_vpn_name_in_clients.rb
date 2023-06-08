class RenameVpnToVpnNameInClients < ActiveRecord::Migration[7.0]
  def change
    rename_column :clients, :vpn, :vpnName

  end
end
