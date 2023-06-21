class Client < ApplicationRecord
    belongs_to :vpn
    has_one_attached :file
end
