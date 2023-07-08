FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    encrypted_password { 'encrypted_password' }
    admin { false }
    user { Faker::Name.name }
    vpn_admin_List { Faker::Lorem.word }
    admin_vpn { false }
    vpn_list { Faker::Lorem.word }
  end
end