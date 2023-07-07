FactoryBot.define do
  factory :server do
    name { Faker::Name.name }
    CAcert { Faker::Lorem.word }
    CAkey { Faker::Lorem.word }
  end
end