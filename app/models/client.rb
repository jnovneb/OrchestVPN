class Client < ApplicationRecord
    belongs_to :vpn, dependent: :destroy
    has_one_attached :file
end
