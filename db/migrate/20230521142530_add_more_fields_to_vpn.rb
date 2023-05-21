class AddMoreFieldsToVpn < ActiveRecord::Migration[7.0]
  def change
    add_column :vpns, :users, :string
    add_column :vpns, :encrypted_password, :string
  end
end
