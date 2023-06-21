class AddDependentDestroyToClients < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :clients, :vpns
    add_foreign_key :clients, :vpns, on_delete: :cascade
  end
end
