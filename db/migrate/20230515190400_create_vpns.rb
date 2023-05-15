class CreateVpns < ActiveRecord::Migration[7.0]
  def change
    create_table :vpns do |t|
      t.string :name
      t.text :description
      t.string :protocol
      t.integer :port
      t.string :server
      t.text :options
      t.string :technology
      t.string :VPNAdminList
      t.string :version

      t.timestamps
    end
  end
end
