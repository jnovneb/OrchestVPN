class AddFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :user, :string
    add_column :users, :vpn_admin_List, :string
    add_column :users, :admin_vpn, :boolean
    add_column :users, :vpn_list, :string
  end
end
