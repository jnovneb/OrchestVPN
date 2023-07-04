# Generate a factory for the Servers table
FactoryBot.define do
  factory :server do
    name   { Faker::Internet.domain_name }
    CAcert { Faker::Crypto.sha512 }
    CAkey  { Faker::Crypto.sha256 }
  end
end
