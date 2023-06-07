class AddOptionsToServer < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :options, :string
  end
end
