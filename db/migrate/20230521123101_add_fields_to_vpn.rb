class AddFieldsToVpn < ActiveRecord::Migration[7.0]
  def change
    add_column :vpns, :vpn, :string
    add_column :vpns, :name, :string
    add_column :vpns, :description, :string
    add_column :vpns, :protocol, :string
    add_column :vpns, :port, :integer
    add_column :vpns, :encryption, :string
    add_column :vpns, :options, :string
    add_column :vpns, :certificate, :string
    add_column :vpns, :server, :string
    add_column :vpns, :version, :string
    add_column :vpns, :clientoptions, :string
    add_column :vpns, :VPNAdminList, :string
  end
end
