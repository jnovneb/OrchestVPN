require "rails_helper"

RSpec.describe VpnNewsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/vpn_news").to route_to("vpn_news#index")
    end

    it "routes to #new" do
      expect(get: "/vpn_news/new").to route_to("vpn_news#new")
    end

    it "routes to #show" do
      expect(get: "/vpn_news/1").to route_to("vpn_news#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/vpn_news/1/edit").to route_to("vpn_news#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/vpn_news").to route_to("vpn_news#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/vpn_news/1").to route_to("vpn_news#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/vpn_news/1").to route_to("vpn_news#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/vpn_news/1").to route_to("vpn_news#destroy", id: "1")
    end
  end
end
