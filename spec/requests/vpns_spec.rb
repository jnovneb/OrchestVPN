require 'rails_helper'

RSpec.describe VpnsController, type: :request do
  let(:admin_user) { User.create(admin: true) }
  let(:user)       { User.create(admin: false) }

  before do
    @vpn = Vpn.create(name: 'Test VPN', description: 'Test VPN Description')
  end

  describe 'PATCH #update' do
    let(:updated_name) { 'Updated VPN Name' }

    context 'with valid parameters' do
      let(:valid_params) { { vpn: {name: updated_name} } }
      before do
        sign_in admin_user
      end

      it 'updates the requested vpn' do
        patch :update, params: { id: @vpn.id, vpn: valid_params }
        @vpn.reload
        expect(@vpn.name).to eq(updated_name)
      end
      it 'redirects to the updated vpn' do
        patch :update, params: { id: @vpn.id, vpn: valid_params }
        expect(response).to redirect_to(vpn_path(@vpn))
        expect(response).to have_http_status(302)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { {vpn: {name: ''}} }
      before do
        sign_in admin_user
      end

      it 'does not update the requested vpn' do
        patch :update, params: { id: @vpn.id, vpn: invalid_params }
        @vpn.reload
        expect(@vpn.name).not_to be_blank
      end
      it 'renders the edit template' do
        patch :update, params: { id: @vpn.id, vpn: invalid_params }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'GET #index' do
    let(:admin_user) { create(:user, admin: true) }
    let(:non_admin_user) { create(:user, admin: false) }

    context 'when the user is an admin' do
      let!(:vpns) { create_list(:vpn, 3) }
      before do
        sign_in(admin_user)
        get '/vpns'
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(200)
      end
      it 'assigns all VPNs to @vpns' do
        expect(assigns(:vpns)).to match_array(vpns)
      end
    end

    context 'when the user is not an admin' do
      let(:admin_vpns) { create_list(:vpn, 2, admin_vpn: true) }
      let(:non_admin_vpns) { create_list(:vpn, 3, admin_vpn: false) }
      let!(:user_vpns) { create_list(:users_vpn, 2, user: non_admin_user, vpn: admin_vpns.first) }
      before do
        sign_in non_admin_user
        get '/vpns'
      end

      it 'assigns the admin vpns to @vpns' do
        expect(assigns(:vpns)).to match_array(admin_vpns)
      end
      it 'does not assign the non-admin vpns to @vpns' do
        expect(assigns(:vpns)).not_to include(non_admin_vpns)
      end
      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
      it 'returns a successful response' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when user is not signed in' do
      it 'redirects to the sign in page' do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested vpn to @vpn' do
      get :show, params: { id: @vpn.id }
      expect(assigns(:vpn)).to eq(@vpn)
    end
    it 'renders the show template' do
      get :show, params: { id: @vpn.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new vpn to @vpn' do
      get :new
      expect(assigns(:vpn)).to be_a_new(Vpn)
    end
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested vpn to @vpn' do
      get :edit, params: { id: @vpn.id }
      expect(assigns(:vpn)).to eq(@vpn)
    end
    it 'renders the edit template' do
      get :edit, params: { id: @vpn.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { { vpn: {name: 'New VPN', description: 'New VPN Description'} } }

      before do
        sign_in admin_user
      end

      it 'creates a new vpn' do
        expect {
          post :create, params: valid_params
        }.to change(Vpn, :count).by(1)
      end
      it 'redirects to the created vpn' do
        post :create, params: valid_params
        expect(response).to redirect_to(vpn_path(Vpn.last))
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { vpn: {name: '', description: 'New VPN Description'} } }

      before do
        sign_in admin_user
      end

      it 'does not create a new vpn' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Vpn, :count)
      end
      it 'renders the new template' do
        post :create, params: invalid_params
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in admin_user
    end

    it 'destroys the requested vpn' do
      expect {
        delete :destroy, params: { id: @vpn.id }
      }.to change(Vpn, :count).by(-1)
    end
    it 'redirects to the vpns index' do
      delete :destroy, params: { id: @vpn.id }
      expect(response).to redirect_to(vpns_path)
    end
  end
end