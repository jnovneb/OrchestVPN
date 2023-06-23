class RenameHostkeyToCAkeyInServers < ActiveRecord::Migration[7.0]
  def change
    rename_column :servers, :hostkey, :CAkey
  end
end
