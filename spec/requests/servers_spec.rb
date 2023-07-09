require 'rails_helper'

RSpec.describe "/servers", type: :request do
  let(:valid_attributes) { attributes_for(:server) }
  let(:invalid_attributes) { attributes_for(:server, name: '') }

  describe 'GET #index' do
    it 'renders the index template' do
      get servers_path
      expect(response).to render_template(:index)
    end
    it 'returns a successful response' do
      get servers_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #show' do
    let(:server) { create(:server) }

    it 'renders the show template' do
      get server_path(server)
      expect(response).to render_template(:show)
    end
    it 'returns a successful response' do
      get server_path(server)
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get new_server_path
      expect(response).to render_template(:new)
    end
    it 'returns a successful response' do
      get new_server_path
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    let(:server_params) { attributes_for(:server) }

    context 'with valid parameters' do
      it 'creates a new server' do
        expect {
          post servers_path, params: { server: server_params }
        }.to change(Server, :count).by(1)
      end
      it 'redirects to the created server' do
        post servers_path, params: { server: server_params }
        expect(response).to redirect_to(server_path(Server.last))
      end
      it 'sets the flash notice' do
        post servers_path, params: { server: server_params }
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { attributes_for(:server, name: '') }

      it 'does not create a new server' do
        expect {
          post servers_path, params: { server: invalid_params }
        }.to_not change(Server, :count)
      end
      it 'renders the new template' do
        post servers_path, params: { server: invalid_params }
        expect(response).to render_template(:new)
      end
      it 'sets the flash alert' do
        post servers_path, params: { server: invalid_params }
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET #edit' do
    let(:server) { create(:server) }

    it 'renders the edit template' do
      get edit_server_path(server)
      expect(response).to render_template(:edit)
    end
    it 'returns a successful response' do
      get edit_server_path(server)
      expect(response).to have_http_status(200)
    end
  end

  describe 'PATCH #update' do
    let!(:server) { create(:server) }
    let(:updated_name) { 'Updated Name' }

    context 'with valid parameters' do
      it 'updates the server' do
        patch server_path(server), params: { server: { name: updated_name } }
        expect(server.reload.name).to eq(updated_name)
      end
      it 'redirects to the updated server' do
        patch server_path(server), params: { server: { name: updated_name } }
        expect(response).to redirect_to(server_path(server))
      end
      it 'sets the flash notice' do
        patch server_path(server), params: { server: { name: updated_name } }
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { name: '' } }

      it 'does not update the server' do
        expect {
          patch server_path(server), params: { server: invalid_params }
        }.to_not change { server.reload.name }
      end
      it 'renders the edit template' do
        patch server_path(server), params: { server: invalid_params }
        expect(response).to render_template(:edit)
      end
      it 'sets the flash alert' do
        patch server_path(server), params: { server: invalid_params }
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:server) { create(:server) }

    it 'destroys the server' do
      expect {
        delete server_path(server)
      }.to change(Server, :count).by(-1)
    end
    it 'redirects to the servers index' do
      delete server_path(server)
      expect(response).to redirect_to(servers_path)
    end
    it 'sets the flash notice' do
      delete server_path(server)
      expect(flash[:notice]).to be_present
    end
  end
end
