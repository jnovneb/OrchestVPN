class RemoveEncryptionFromVpns < ActiveRecord::Migration[7.0]
  def change
    remove_column :vpns, :encryption
  end
end
