class AddManyUsersToVpn < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :vpn, null: false, foreign_key: true, default: 0
  end
end
