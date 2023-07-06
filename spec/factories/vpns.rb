# spec/factories/vpns.rb
require 'faker'

FactoryBot.define do
  factory :vpn do
    vpn { Faker::Name.name }
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
    protocol { Faker::Internet.slug }
    port { Faker::Internet.slug }
    options { Faker::Lorem.sentence }
    certificate { Faker::Lorem.sentence }
    version { Faker::Internet.slug }
    VPNAdminList { Faker::Lorem.sentence }
    users { Faker::Lorem.sentence }
    vpn_admin_list { Faker::Lorem.sentence }
    bandwidth { Faker::Number.number(8)}
    CIDR { Faker::Internet.ip_v4_cidr }
    server_id { Faker::Number.number(8)}
    hostkey { Faker::Lorem.sentence }
    managementPort { Faker::Internet.slug }
  end
end
