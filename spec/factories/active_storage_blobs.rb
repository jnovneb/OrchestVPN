FactoryBot.define do
  factory :active_storage_blob do
    key { Faker::Alphanumeric.alphanumeric(number: 20) }
    filename { Faker::File.file_name }
    content_type { 'image/png' }
    byte_size { 1024 }
    service_name { 'local' }
    checksum { 'xyz123' }
  end
end