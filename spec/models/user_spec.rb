require 'rails_helper'

RSpec.describe 'User' do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:encrypted_password) }
  end

  describe 'associations' do
    it { should have_many(:users_vpns) }
    it { should have_many(:vpns).through(:users_vpns) }
  end

  describe 'attributes' do
    it { should respond_to(:email) }
    it { should respond_to(:encrypted_password) }
    it { should respond_to(:reset_password_token) }
    it { should respond_to(:reset_password_sent_at) }
    it { should respond_to(:remember_created_at) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
    it { should respond_to(:admin) }
    it { should respond_to(:user) }
    it { should respond_to(:vpn_admin_List) }
    it { should respond_to(:admin_vpn) }
    it { should respond_to(:vpn_list) }
  end
end
