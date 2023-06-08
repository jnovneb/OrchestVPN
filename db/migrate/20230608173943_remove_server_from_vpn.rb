class RemoveServerFromVpn < ActiveRecord::Migration[7.0]
  def change
    remove_column :vpns, :server, :string
  end
end
