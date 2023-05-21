class CreateVpns < ActiveRecord::Migration[7.0]
  def change
    create_table :vpns do |t|

      t.timestamps
    end
  end
end
