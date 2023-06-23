class RemoveAddrFromServers < ActiveRecord::Migration[7.0]
  def change
    remove_column :servers, :addr
  end
end
