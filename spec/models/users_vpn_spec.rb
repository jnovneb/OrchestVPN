require 'rails_helper'

RSpec.describe UsersVpn, type: :model do
  before { FactoryBot.build(:users_vpn) }
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:vpn) }
  end

  describe 'validations' do
    it { should validate_uniqueness_of(:user_id).scoped_to(:vpn_id) }
  end
end
