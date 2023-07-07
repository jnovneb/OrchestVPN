require 'rails_helper'

RSpec.describe 'ActiveStorage Attachments', type: :model do
  it 'is valid with required attributes' do
    attachment = active_storage_attachments.new(name: 'file.txt', record_type: 'User', record_id: 1, blob_id: 1)
    expect(attachment).to be_valid
  end
  it 'is invalid without a name' do
    attachment = active_storage_attachments.new(record_type: 'User', record_id: 1, blob_id: 1)
    expect(attachment).to be_invalid
    expect(attachment.errors[:name]).to include("can't be blank")
  end
  it 'is invalid without a record_type' do
    attachment = active_storage_attachments.new(name: 'file.txt', record_id: 1, blob_id: 1)
    expect(attachment).to be_invalid
    expect(attachment.errors[:record_type]).to include("can't be blank")
  end

  it 'has a unique name within the scope of record_type, record_id, and blob_id' do
    existing_attachment = create(:active_storage_attachment)
    attachment = active_storage_attachments.new(name: existing_attachment.name,
                                                record_type: existing_attachment.record_type,
                                                record_id: existing_attachment.record_id,
                                                blob_id: existing_attachment.blob_id)
    expect(attachment).to be_invalid
    expect(attachment.errors[:name]).to include('has already been taken')
  end

  it 'belongs to an ActiveStorageBlob' do
    attachment = create(:active_storage_attachment)
    expect(attachment.blob).to be_an_instance_of(ActiveStorageBlob)
  end
end