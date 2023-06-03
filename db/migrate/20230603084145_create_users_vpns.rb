class CreateUsersVpns < ActiveRecord::Migration[7.0]
  def change
    create_table :users_vpns do |t|
      t.references :user, null: false, foreign_key: true
      t.references :vpn, null: false, foreign_key: true

      t.timestamps
    end
    add_index :users_vpns, [:user_id, :vpn_id], unique: true
  end
end