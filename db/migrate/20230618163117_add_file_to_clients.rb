class AddFileToClients < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :file, :binary
  end
end
