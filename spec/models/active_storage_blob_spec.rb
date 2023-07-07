require 'rails_helper'

RSpec.describe 'ActiveStorage Blob', type: :model do
  it 'is valid with valid attributes' do
    blob = FactoryBot.build(:active_storage_blob)
    expect(blob).to be_valid
  end
  it 'is not valid without a key' do
    blob = FactoryBot.build(:active_storage_blob, key: nil)
    expect(blob).to_not be_valid
  end
  it 'is not valid without a filename' do
    blob = FactoryBot.build(:active_storage_blob, filename: nil)
    expect(blob).to_not be_valid
  end

end
