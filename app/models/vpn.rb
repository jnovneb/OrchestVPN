class Vpn < ApplicationRecord
    has_many :users_vpns
    has_many :users, through: :users_vpns
end
