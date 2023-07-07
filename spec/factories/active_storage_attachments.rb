FactoryBot.define do
  factory :active_storage_attachment do
    name { Faker::Lorem.word }
    association :record, factory: :user
    association :blob, factory: :active_storage_blob
  end
end