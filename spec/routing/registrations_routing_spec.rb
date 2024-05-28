require "rails_helper"

RSpec.describe RegistrationsController, type: :routing do
  describe "routing" do
    it "routes to #me" do
      expect(get: "/me").to route_to("registrations#me")
    end

    it "routes to #create" do
      expect(post: "/new").to route_to("registrations#create")
    end

    it "routes to #sign_in" do
      expect(post: "/sign_in").to route_to("registrations#sign_in")
    end

    it "routes to #new_token" do
      expect(post: "/new_token").to route_to("registrations#new_token")
    end
  end
end
