require 'rails_helper'

RSpec.describe ClientsController, type: :controller do
  let(:vpn) { Vpn.create(name: 'Test VPN', server: Server.create(name: 'Test Server')) }

  before do
    @client = Client.create(name: 'Test Client', vpn: vpn)
  end

  describe 'GET #index' do
    it 'assigns all clients to @clients' do
      get :index
      expect(assigns(:clients)).to eq(Client.all)
    end
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested client to @client' do
      get :show, params: { id: @client.id }
      expect(assigns(:client)).to eq(@client)
    end

    it 'renders the show template' do
      get :show, params: { id: @client.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new client to @client' do
      get :new
      expect(assigns(:client)).to be_a_new(Client)
    end

    it 'assigns the vpn name to @vpn_name' do
      get :new, params: { vpn_name: 'Test VPN' }
      expect(assigns(:vpn_name)).to eq('Test VPN')
    end
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested client to @client' do
      get :edit, params: { id: @client.id }
      expect(assigns(:client)).to eq(@client)
    end
    it 'renders the edit template' do
      get :edit, params: { id: @client.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { client: {name: 'New Client', vpnName: vpn.name} } }

    before do
      allow(controller).to receive(:system)
    end

    it 'creates a new client' do
      expect {
        post :create, params: valid_params
      }.to change(Client, :count).by(1)
    end
    it 'assigns the vpn_id based on vpnName' do
      post :create, params: valid_params
      expect(assigns(:client).vpn_id).to eq(vpn.id)
    end
    it 'redirects to the created client' do
      post :create, params: valid_params
      expect(response).to redirect_to(client_path(Client.last))
    end
  end

  describe 'PATCH #update' do
    let(:valid_params) { { client: {name: 'Updated Client'} } }

    it 'updates the requested client' do
      patch :update, params: { id: @client.id, client: valid_params }
      @client.reload
      expect(@client.name).to eq('Updated Client')
    end
    it 'redirects to the updated client' do
      patch :update, params: { id: @client.id, client: valid_params }
      expect(response).to redirect_to(client_path(@client))
    end
  end

  describe 'DELETE #destroy' do
    before do
      allow(controller).to receive(:system)
    end

    it 'destroys the requested client' do
      expect {
        delete :destroy, params: { id: @client.id }
      }.to change(Client, :count).by(-1)
    end
    it 'redirects to the clients index' do
      delete :destroy, params: { id: @client.id }
      expect(response).to redirect_to(clients_path)
    end
  end
end
