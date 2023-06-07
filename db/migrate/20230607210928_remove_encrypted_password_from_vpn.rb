class RemoveEncryptedPasswordFromVpn < ActiveRecord::Migration[7.0]
  def change
    remove_column :vpns, :encrypted_password, :string
  end
end
