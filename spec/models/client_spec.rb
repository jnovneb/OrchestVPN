require 'rails_helper'

RSpec.describe Client, type: :model do
  before { FactoryBot.build(:client) }
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:vpn) }
  end
end
