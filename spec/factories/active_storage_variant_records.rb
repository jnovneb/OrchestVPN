FactoryBot.define do
  factory :active_storage_variant_record do
    association :blob, factory: :active_storage_blob
    variation_digest { Faker::Alphanumeric.alphanumeric(number: 20) }
  end
end