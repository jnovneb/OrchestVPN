class AddForeignKeyToClients < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :clients, :vpns, on_delete: :cascade
  end
end
