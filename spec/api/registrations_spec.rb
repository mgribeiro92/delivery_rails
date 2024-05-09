require "rails_helper"

RSpec.describe "registrations", type: :request do
  let(:credential) {
    Credential.create_access(:buyer)
  }

  let(:user) {
    user = User.new(
      email: "email@example.com",
      password: "123456",
      role: "buyer"
    )
    user.save!
    user
  }

  describe "POST /new" do
    it "creates a buyer user" do
      post(
        create_registration_url,
        headers: {
          "Accept" => "application/json",
          "X-API-KEY" => credential.key
        },
        params: {
          user: {
            email: "buyer_user@example.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }
      )

      user = User.find_by(
        email: "buyer_user@example.com"
      )

      expect(response).to be_successful
      expect(user).to be_buyer
    end
  end

  describe "POST /new" do
    it "fail to create user without credentials" do
      post(
        create_registration_url,
        headers: { "Accept" => "application/json" },
        params: {
          user: {
            email: "admin_user@example.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }
      )

      expect(response).to be_unprocessable
    end
  end

  describe "POST /sign_in" do
    it "returns emails or password is incorrect" do
      post(
        '/sign_in',
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json",
          "X-API-KEY" => credential.key
        },
        params: {
          login: {
            email: user.email,
            password: "123457",
          }
        }.to_json
      )
      json = JSON.parse(response.body)

      expect(response).to have_http_status(401)
      expect(json["message"]).to eq("Email or password incorrect!")
    end

    it "gets token and refresh_token for success sign_in" do
      post(
        '/sign_in',
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json",
          "X-API-KEY" => credential.key
        },
        params: {
          login: {
            email: user.email,
            password: user.password
          }
        }.to_json
      )
      json = JSON.parse(response.body)

      expect(json["token"]).to be_present
      expect(json["refresh_token"]).to be_present
    end
  end
end
