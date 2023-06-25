class AddUniqueConstraintToVpns < ActiveRecord::Migration[7.0]
  def change
    add_index :vpns, [:port, :managementPort], unique: true, name: 'index_vpns_on_port_and_management_port'
  end
end
