require 'rails_helper'

RSpec.describe 'ActiveStorage VariantRecord', type: :model do
  it { should belong_to(:blob) }

  it { should validate_presence_of(:blob) }
  it { should validate_presence_of(:variation_digest) }

  it { should have_db_index(:blob_id) }
  it { should have_db_index(:variation_digest) }
end