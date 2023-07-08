FactoryBot.define do
  factory :client do
    vpnName { Faker::Lorem.word }
    name { Faker::Name.name }
    desc { Faker::Lorem.sentence }
    cert { Faker::Lorem.word }
    options { Faker::Lorem.word }
    encrypted_password { 'encrypted_password' }
    association :vpn
  end
end
