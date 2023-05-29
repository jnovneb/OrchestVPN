class CreateServers < ActiveRecord::Migration[7.0]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :addr
      t.string :credentials
      t.string :hostkey
      t.string :CA

      t.timestamps
    end
  end
end
