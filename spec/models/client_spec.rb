require 'rails_helper'

RSpec.describe Client, type: :model do
  before { FactoryBot.build(:client) }
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:vpnName) }
    it { should validate_presence_of(:desc) }
    it { should validate_presence_of(:cert) }
    it { should validate_presence_of(:options) }
  end

  describe 'associations' do
    it { should belong_to(:vpn) }
  end
end
