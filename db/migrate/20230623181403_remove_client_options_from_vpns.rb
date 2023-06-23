class RemoveClientOptionsFromVpns < ActiveRecord::Migration[7.0]
  def change
    remove_column :vpns, :clientoptions
  end
end
