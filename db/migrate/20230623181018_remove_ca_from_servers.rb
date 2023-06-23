class RemoveCaFromServers < ActiveRecord::Migration[7.0]
  def change
    remove_column :servers, :CA
  end
end
