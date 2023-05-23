class AddBandwidthToVpn < ActiveRecord::Migration[7.0]
  def change
    add_column :vpns, :bandwidth, :integer
  end
end
