class AddManagementPortToVpns < ActiveRecord::Migration[7.0]
  def change
    add_column :vpns, :managementPort, :string
  end
end
