class AddCidrToVpn < ActiveRecord::Migration[7.0]
  def change
    add_column :vpns, :CIDR, :string
  end
end
