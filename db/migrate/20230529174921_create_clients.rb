class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :vpn
      t.string :name
      t.string :desc
      t.string :cert
      t.string :options

      t.timestamps
    end
  end
end
