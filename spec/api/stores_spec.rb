require "rails_helper"

RSpec.describe "/stores", type: :request do

  let(:user) {
    user = User.new(
      email: "user@example.com.br",
      password: "123456",
      password_confirmation: "123456",
      role: "seller"
    )
    user.save!
    user
  }

  let(:valid_attributes) {
    {name: "New Store", user: user}
  }

  let(:invalid_attributes) {
    {name: nil}
  }

  let(:credential) { Credential.create_access(:seller) }

  let(:signed_in) { api_sign_in(user, credential )}

  describe "GET /show" do
    it "render a successful response with stores data" do
      store = Store.create! valid_attributes
      get "/stores/#{store.id}",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in["token"]}"
      }
      json = JSON.parse(response.body)
      expect(json["name"]).to eq "New Store"
    end
  end
end

