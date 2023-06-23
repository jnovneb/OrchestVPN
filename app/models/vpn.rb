class Vpn < ApplicationRecord
    has_many :users_vpns
    has_many :users, through: :users_vpns
    has_many :clients, dependent: :destroy
    belongs_to :server
    #validates_presence_of :server_id
end
