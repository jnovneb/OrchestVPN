require 'rails_helper'

RSpec.describe "VpnManagers", type: :request do
  describe "GET /status" do
    it "returns http success" do
      get "/vpn_manager/status"
      expect(response).to have_http_status(:success)
    end
  end

end
