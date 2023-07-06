# Generate a factory for the Clients table
FactoryBot.define do
  factory :client do
    vpnName            { Faker::Name.last_name}
    name               { Faker::App.name }
    desc               { Faker::Lorem.sentence }
    cert               { Faker::Lorem.sentence }
    options            { Faker::Lorem.sentence }
    encrypted_password { Faker::Internet.password }
    vpn_id             { Faker::Number.number(digits: 8) }
  end
end