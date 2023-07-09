require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:users_vpns) }
    it { should have_many(:vpns).through(:users_vpns) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:encrypted_password) }
    it { should validate_presence_of(:password) }
  end

  describe 'callbacks' do
    describe 'before_destroy' do
      let(:user) { create(:user) }

      it 'destroys associated users_vpns' do
        user.users_vpns << create(:users_vpn)
        expect { user.destroy }.to change(UsersVpn, :count).by(-1)
      end
    end
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

  describe 'methods' do
    let(:user) { create(:user) }

    describe '#authenticate_admin!' do
      it 'redirects to :somewhere with status :forbidden if current user is not an admin' do
        allow(user).to receive(:authenticate_user!)
        allow(user).to receive(:current_user).and_return(user)
        allow(user).to receive(:admin?).and_return(false)
        expect(user).to receive(:redirect_to).with(:somewhere, status: :forbidden)
        user.authenticate_admin!
      end
      it 'does not redirect if current user is an admin' do
        allow(user).to receive(:authenticate_user!)
        allow(user).to receive(:current_user).and_return(user)
        allow(user).to receive(:admin?).and_return(true)
        expect(user).not_to receive(:redirect_to)
        user.authenticate_admin!
      end
    end

    describe '#current_user' do
      context 'when session[:user_id] is present' do
        it 'returns the user with matching session[:user_id]' do
          session = { user_id: user.id }
          expect(User).to receive(:find).with(user.id).and_return(user)
          expect(user.current_user(session)).to eq(user)
        end
      end

      context 'when session[:user_id] is not present' do
        it 'returns nil' do
          session = {}
          expect(User).not_to receive(:find)
          expect(user.current_user(session)).to be_nil
        end
      end
    end

    describe '#signed_in?' do
      it 'returns true if current_user is present' do
        allow(user).to receive(:current_user).and_return(user)
        expect(user.signed_in?).to be true
      end
      it 'returns false if current_user is not present' do
        allow(user).to receive(:current_user).and_return(nil)
        expect(user.signed_in?).to be false
      end
    end

    describe '#is_admin?' do
      it 'returns true if signed_in? and current_user.admin is true' do
        allow(user).to receive(:signed_in?).and_return(true)
        allow(user).to receive(:current_user).and_return(user)
        allow(user).to receive(:admin).and_return(true)
        expect(user.is_admin?).to be true
      end
      it 'returns false if signed_in? is false' do
        allow(user).to receive(:signed_in?).and_return(false)
        expect(user.is_admin?).to be false
      end
      it 'returns false if current_user.admin is false' do
        allow(user).to receive(:signed_in?).and_return(true)
        allow(user).to receive(:current_user).and_return(user)
        allow(user).to receive(:admin).and_return(false)
        expect(user.is_admin?).to be false
      end
    end

    describe '#is_vpnadmin?' do
      it 'returns true if signed_in? and current_user.admin_vpn is true' do
        allow(user).to receive(:signed_in?).and_return(true)
        allow(user).to receive(:current_user).and_return(user)
        allow(user).to receive(:admin_vpn).and_return(true)
        expect(user.is_vpnadmin?).to be true
      end
      it 'returns false if signed_in? is false' do
        allow(user).to receive(:signed_in?).and_return(false)
        expect(user.is_vpnadmin?).to be false
      end
      it 'returns false if current_user.admin_vpn is false' do
        allow(user).to receive(:signed_in?).and_return(true)
        allow(user).to receive(:current_user).and_return(user)
        allow(user).to receive(:admin_vpn).and_return(false)
        expect(user.is_vpnadmin?).to be false
      end
    end
  end
end
