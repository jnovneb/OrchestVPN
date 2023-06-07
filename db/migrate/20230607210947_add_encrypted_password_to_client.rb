class AddEncryptedPasswordToClient < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :encrypted_password, :string
  end
end
