FactoryBot.define do
  factory :users_vpn do
    association :user
    association :vpn
    admin_vpn { false }
  end
end