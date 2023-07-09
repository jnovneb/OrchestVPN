require 'rails_helper'

RSpec.describe ClientsController, type: :request do
  let(:vpn) { Vpn.create(name: 'Test VPN', server: Server.create(name: 'Test Server')) }
  before do
    @client = Client.create(name: 'Test Client', vpn: vpn)
  end


  describe 'GET #index' do
    let!(:clients) { create_list(:client, 3) }
    before { get :index }

    it 'assigns all clients to @clients' do
      expect(assigns(:clients)).to match_array(clients)
    end
    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
    it 'returns a successful response' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #show' do
    let(:client) { create(:client) }
    before { get :show, params: { id: client.id } }

    it 'assigns the requested client to @client' do
      expect(assigns(:client)).to eq(client)
    end
    it 'renders the show template' do
      expect(response).to render_template(:show)
    end
    it 'returns a successful response' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #new' do
    let(:vpn_name) { 'Example VPN' }
    before { get :new, params: { vpn_name: vpn_name } }

    it 'assigns a new client to @client' do
      expect(assigns(:client)).to be_a_new(Client)
    end
    it 'assigns the VPN name to @vpn_name' do
      expect(assigns(:vpn_name)).to eq(vpn_name)
    end
    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
    it 'returns a successful response' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    let(:vpn) { create(:vpn) }
    let(:client_params) { attributes_for(:client, vpn_id: vpn.id) }

    context 'with valid parameters' do
      it 'creates a new client' do
        expect {
          post :create, params: { client: client_params }
        }.to change(Client, :count).by(1)
      end
      it 'redirects to the created client' do
        post :create, params: { client: client_params }
        expect(response).to redirect_to(client_path(Client.last))
      end
      it 'sets the flash notice' do
        post :create, params: { client: client_params }
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { attributes_for(:client, name: '') }

      it 'does not create a new client' do
        expect {
          post :create, params: { client: invalid_params }
        }.to_not change(Client, :count)
      end
      it 'renders the new template' do
        post :create, params: { client: invalid_params }
        expect(response).to render_template(:new)
      end
      it 'sets the flash alert' do
        post :create, params: { client: invalid_params }
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET #edit' do
    let(:client) { create(:client) }
    before { get :edit, params: { id: client.id } }

    it 'assigns the requested client to @client' do
      expect(assigns(:client)).to eq(client)
    end
    it 'renders the edit template' do
      expect(response).to render_template(:edit)
    end
    it 'returns a successful response' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH #update' do
    let!(:client) { create(:client) }
    let(:updated_name) { 'Updated Name' }

    context 'with valid parameters' do
      it 'updates the client' do
        patch :update, params: { id: client.id, client: { name: updated_name } }
        expect(client.reload.name).to eq(updated_name)
      end
      it 'redirects to the updated client' do
        patch :update, params: { id: client.id, client: { name: updated_name } }
        expect(response).to redirect_to(client_path(client))
      end
      it 'sets the flash notice' do
        patch :update, params: { id: client.id, client: { name: updated_name } }
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { name: '' } }

      it 'does not update the client' do
        expect {
          patch :update, params: { id: client.id, client: invalid_params }
        }.to_not change { client.reload.name }
      end
      it 'renders the edit template' do
        patch :update, params: { id: client.id, client: invalid_params }
        expect(response).to render_template(:edit)
      end
      it 'sets the flash alert' do
        patch :update, params: { id: client.id, client: invalid_params }
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:client) { create(:client) }

    it 'destroys the client' do
      expect {
        delete :destroy, params: { id: client.id }
      }.to change(Client, :count).by(-1)
    end
    it 'redirects to the clients index' do
      delete :destroy, params: { id: client.id }
      expect(response).to redirect_to(clients_path)
    end
    it 'sets the flash notice' do
      delete :destroy, params: { id: client.id }
      expect(flash[:notice]).to be_present
    end
  end
end
