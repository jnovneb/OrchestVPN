# spec/factories/vpns.rb
require 'faker'

FactoryBot.define do
  factory :vpn do
    vpn { Faker::Lorem.word }
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    protocol { 'udp' }
    port { 1194 }
    options { Faker::Lorem.word }
    certificate { Faker::Lorem.word }
    version { '2.4' }
    VPNAdminList { Faker::Lorem.word }
    users { Faker::Lorem.word }
    vpn_admin_list { Faker::Lorem.word }
    bandwidth { 100 }
    CIDR { '10.0.0.0/24' }
    association :server
    hostkey { Faker::Lorem.word }
    managementPort { '5555' }
  end
end