require "rails_helper"

RSpec.describe VpnsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/vpns").to route_to("vpns#index")
    end

    it "routes to #new" do
      expect(get: "/vpns/new").to route_to("vpns#new")
    end

    it "routes to #show" do
      expect(get: "/vpns/1").to route_to("vpns#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/vpns/1/edit").to route_to("vpns#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/vpns").to route_to("vpns#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/vpns/1").to route_to("vpns#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/vpns/1").to route_to("vpns#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/vpns/1").to route_to("vpns#destroy", id: "1")
    end
  end
end
