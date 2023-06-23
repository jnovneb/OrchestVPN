class RemoveOptionsFromServers < ActiveRecord::Migration[7.0]
  def change
    remove_column :servers, :options
  end
end
