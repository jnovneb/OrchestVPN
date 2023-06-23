class AddHostkeyToVpn < ActiveRecord::Migration[7.0]
  def change
    add_column :vpns, :hostkey, :string
  end
end
