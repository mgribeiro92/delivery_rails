require "rails_helper"

RSpec.describe OrdersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/buyers/orders").to route_to("orders#index")
    end

    it "routes to #listing" do
      expect(get: "/orders").to route_to("orders#listing")
    end

    it "routes to #new" do
      expect(get: "/orders/new").to route_to("orders#new")
    end

    it "routes to #show" do
      expect(get: "/buyers/orders/1").to route_to("orders#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/orders/1/edit").to route_to("orders#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/buyers/orders").to route_to("orders#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/buyers/orders/1").to route_to("orders#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/buyers/orders/1").to route_to("orders#update", id: "1")
    end

    it "routes to #sellers via GET" do
      expect(get: "/orders_seller/1").to route_to("orders#sellers", id: "1")
    end

    it "routes to #change_state via POST" do
      expect(post: "/change_state/").to route_to("orders#change_state")
    end

    it "routes to #destroy" do
      expect(delete: "/orders/1").to route_to("orders#destroy", id: "1")
    end
  end
end
