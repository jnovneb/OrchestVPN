require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create(email: 'test@example.com') }

  describe 'GET #index' do
    it 'assigns a new user to @user' do
      get :index
      expect(assigns(:user)).to be_a_new(User)
    end
    it 'assigns non-admin users to @non_admins' do
      non_admins = User.where(admin: false)
      get :index
      expect(assigns(:non_admins)).to eq(non_admins)
    end
    it 'assigns admin users to @admins' do
      admins = User.where(admin: true)
      get :index
      expect(assigns(:admins)).to eq(admins)
    end
    it 'assigns the selected user to @selected_user' do
      selected_user = User.find(1)
      get :index, params: { selected_user_id: selected_user.id }
      expect(assigns(:selected_user)).to eq(selected_user)
    end
    it 'assigns all users to @users' do
      users = User.all
      get :index
      expect(assigns(:users)).to eq(users)
    end
    it 'assigns the selected user ID to @selected_user_id' do
      selected_user_id = 1
      get :index, params: { selected_user_id: selected_user_id }
      expect(assigns(:selected_user_id)).to eq(selected_user_id)
    end
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user to @user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
    it 'renders the show template' do
      get :show, params: { id: user.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested user to @user' do
      get :edit, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end
    it 'renders the edit template' do
      get :edit, params: { id: user.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { user: {email: 'new_user@example.com'} } }

    it 'creates a new user' do
      expect {
        post :create, params: valid_params
      }.to change(User, :count).by(1)
    end
    it 'redirects to the created user' do
      post :create, params: valid_params
      expect(response).to redirect_to(user_path(User.last))
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) { { user: {email: 'updated_user@example.com'} } }

    it 'updates the requested user' do
      patch :update, params: { id: user.id, user: valid_params }
      user.reload
      expect(user.email).to eq('updated_user@example.com')
    end
    it 'redirects to the updated user' do
      patch :update, params: { id: user.id, user: valid_params }
      expect(response).to redirect_to(user_path(user))
    end
  end

  describe 'PATCH #move_to_admins' do
    it 'updates the admin attribute of the requested user to true' do
      patch :move_to_admins, params: { id: user.id }
      user.reload
      expect(user.admin).to eq(true)
    end
    it 'redirects to the users index' do
      patch :move_to_admins, params: { id: user.id }
      expect(response).to redirect_to(users_path)
    end
  end

  describe 'PATCH #move_to_non_admins' do
    before do
      user.update(admin: true)
    end

    it 'updates the admin attribute of the requested user to false' do
      patch :move_to_non_admins, params: { id: user.id }
      user.reload
      expect(user.admin).to eq(false)
    end
    it 'redirects to the users index' do
      patch :move_to_non_admins, params: { id: user.id }
      expect(response).to redirect_to(users_path)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested user' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
    end
    it 'redirects to the users index' do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(users_path)
    end
  end

  describe 'POST #addusersvpn' do
    let(:vpn) { Vpn.create(name: 'Test VPN') }

    it 'adds users to the specified VPN' do
      user_ids = [1, 2, 3]
      post :addusersvpn, params: { user: { vpn_id: vpn.id, user_add_ids: user_ids } }
      expect(UsersVpn.where(vpn_id: vpn.id, user_id: user_ids)).to exist
    end
    it 'redirects to the users index' do
      post :addusersvpn, params: { user: { vpn_id: vpn.id, user_add_ids: [1, 2, 3] } }
      expect(response).to redirect_to(users_path)
    end
  end

  describe 'POST #delusersvpn' do
    let(:vpn) { Vpn.create(name: 'Test VPN') }

    before do
      UsersVpn.create(user_id: 1, vpn_id: vpn.id)
      UsersVpn.create(user_id: 2, vpn_id: vpn.id)
      UsersVpn.create(user_id: 3, vpn_id: vpn.id)
    end

    it 'deletes users from the specified VPN' do
      user_deleted = [1, 3]
      post :delusersvpn, params: { user: { vpn_id: vpn.id, user_del_ids: user_deleted } }
      expect(UsersVpn.where(vpn_id: vpn.id, user_id: user_deleted)).not_to exist
    end
  end

  describe 'GET #options' do
    let(:vpn) { Vpn.create(name: 'Test VPN') }
    let(:users) { [User.create(email: 'user1@example.com', id: 1), User.create(email: 'user2@example.com', id: 2)] }

    before do
      allow(User).to receive(:where).and_return(users)
      allow(users).to receive(:where).and_return(users)
      allow(users).to receive(:pluck).and_return([['user1@example.com', 1], ['user2@example.com', 2]])
    end

    it 'renders options for users without the specified VPN' do
      get :options, params: { vpn_id: vpn.id }
      expect(response.body).to eq(options_for_select([['user1@example.com', 1], ['user2@example.com', 2]]).to_json)
    end
  end

  private

  def options_for_select(users)
    # Your implementation of options_for_select
    # ...
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.fetch(:user, {})
  end

  def set_selected_user
    @selected_user = User.find_by(id: params[:selected_user_id])
  end
end
