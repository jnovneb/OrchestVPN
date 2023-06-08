class AddVpnIdToClients < ActiveRecord::Migration[7.0]
  def change
    add_reference :clients, :vpn, null: false, foreign_key: true, default: 1
  end

  def down
    remove_reference :clients, :vpn, foreign_key: true
  end
end
