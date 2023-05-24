require 'rails_helper'

RSpec.describe "Scripts", type: :request do
  describe "GET /ejecutar" do
    it "returns http success" do
      get "/scripts/ejecutar"
      expect(response).to have_http_status(:success)
    end
  end

end
