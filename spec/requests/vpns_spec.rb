require 'rails_helper'

RSpec.describe VpnsController, type: :controller do
  let(:admin_user) { User.create(admin: true) }
  let(:user)       { User.create(admin: false) }

  before do
    @vpn = Vpn.create(name: 'Test VPN', description: 'Test VPN Description')
  end

  describe 'GET #index' do
    context 'when user is an admin' do
      before do
        sign_in admin_user
      end

      it 'assigns all vpns to @vpns' do
        get :index
        expect(assigns(:vpns)).to eq(Vpn.all)
      end
      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when user is not an admin' do
      before do
        sign_in user
        @user_vpn = UsersVpn.create(user: user, vpn: @vpn, admin_vpn: true)
      end

      it "assigns user's admin vpns to @vpns" do
        get :index
        expect(assigns(:vpns)).to eq([@vpn])
      end
      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
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

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:valid_params) { { vpn: {name: 'Updated VPN'} } }

      before do
        sign_in admin_user
      end

      it 'updates the requested vpn' do
        patch :update, params: { id: @vpn.id, vpn: valid_params }
        @vpn.reload
        expect(@vpn.name).to eq('Updated VPN')
      end
      it 'redirects to the updated vpn' do
        patch :update, params: { id: @vpn.id, vpn: valid_params }
        expect(response).to redirect_to(vpn_path(@vpn))
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
