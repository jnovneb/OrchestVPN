class RemoveForeignKeyFromClients < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :clients, :vpns
  end
end
