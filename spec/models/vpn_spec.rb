require 'rails_helper'

RSpec.describe Vpn, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:vpn) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:protocol) }
    it { should validate_presence_of(:port) }
    it { should validate_uniqueness_of(:port).scoped_to(:managementPort) }
    it { should validate_presence_of(:options) }
    it { should validate_presence_of(:certificate) }
    it { should validate_presence_of(:version) }
    it { should validate_presence_of(:VPNAdminList) }
    it { should validate_presence_of(:users) }
    it { should validate_presence_of(:vpn_admin_list) }
    it { should validate_presence_of(:bandwidth) }
    it { should validate_presence_of(:CIDR) }
    it { should belong_to(:server) }
    it { should have_many(:clients).dependent(:destroy) }
    it { should have_and_belong_to_many(:users) }
  end

  describe 'associations' do
    it { should belong_to(:server) }
    it { should have_many(:clients).dependent(:destroy) }
    it { should have_and_belong_to_many(:users) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:vpn)).to be_valid
    end
  end
end
