class AddServerIdToVpns < ActiveRecord::Migration[7.0]
  def change
    add_reference :vpns, :server, null: false, foreign_key: true, default: 1
  end

  def down
    remove_reference :vpns, :server, foreign_key: true
  end
end
