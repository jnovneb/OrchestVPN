class UpdateUserIdsInVpns < ActiveRecord::Migration[7.0]
  def change
    def up
      Vpn.find_each do |vpn|
        vpn.update(user_id: 1) # Establece un valor adecuado para user_id
      end
      change_column_null :vpns, :user_id, false
    end
  
    def down
      change_column_null :vpns, :user_id, true
    end
  end
end
