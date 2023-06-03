class UsersVpn < ApplicationRecord
    belongs_to :user
    belongs_to :vpn
end
