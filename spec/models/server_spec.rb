require 'rails_helper'

RSpec.describe Server, type: :model do
  before { FactoryBot.build(:server) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:vpns) }
  end
end
