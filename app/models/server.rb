class Server < ApplicationRecord
    has_many :vpns
    validates :addr, format: { with: /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/, message: "must be a valid IP address" }
    #validates :rangeIP, format: { with: /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/, message: "must be a valid IP address" }
end
