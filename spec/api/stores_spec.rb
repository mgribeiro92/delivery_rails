require "rails_helper"

RSpec.describe "/stores", type: :request do

  let(:seller_1) { create(:user_seller) }
  let(:seller_2) { create(:user_seller) }
  let(:buyer) { create(:user_buyer)}

  let(:stores) do
    seller1_stores = create_list(:store, 5, user: seller_1)
    seller2_stores = create_list(:store, 5, user: seller_2)
    (seller1_stores + seller2_stores)
  end

  let(:valid_attributes) {
    {name: "New Store", user: seller_1}
  }

  let(:invalid_attributes) {
    {name: nil}
  }

  let(:credential_seller) { Credential.create_access(:seller) }
  let(:credential_buyer) { Credential.create_access(:buyer) }

  let(:signed_in_seller) { api_sign_in(seller_1, credential_seller )}
  let(:signed_in_buyer) { api_sign_in(buyer, credential_buyer )}


  describe "GET /index" do
    it "render a successful response with current_user seller to this stores" do
      get "/stores",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_seller["token"]}"
      }
      json = JSON.parse(response.body)
      store_names = json["stores"].map { |store| store["name"] }
      expect(store_names).to match_array(seller_1.stores.map(&:name))
    end

    it "render a successful response with current_user buyer to all stores with soft_delete = false" do
      get "/stores",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_buyer["token"]}"
      }
      json = JSON.parse(response.body)
      puts(json)
      store_names = json["stores"].map { |store| store["name"] }
      expect(store_names).to match_array(stores.map(&:name))
    end
  end

  describe "GET /show" do
    it "render a successful response with stores data" do
      store = Store.create! valid_attributes
      get "/stores/#{store.id}",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_seller["token"]}"
      }
      json = JSON.parse(response.body)
      expect(json["name"]).to eq "New Store"
    end
  end

  describe "POST /create" do
    it "render a successful response to create a new store" do
      post "/stores",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_seller["token"]}",
        "Content-Type" => "application/json"
      },
      params: {
        store: {
          name: "New Store"
        }
      }.to_json
      json = JSON.parse(response.body)
      expect(json["name"]).to eq "New Store"
      expect(json["user_id"]).to eq seller1.id
    end
  end

  describe "PATCH /update" do
    it "render a successful response to update a store" do
      patch "/stores/#{stores[0].id}",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_seller["token"]}",
        "Content-Type" => "application/json"
      },
      params: {
        store: {
          name: "Update a Store"
        }
      }.to_json
      json = JSON.parse(response.body)
      expect(json["name"]).to eq "Update a Store"
    end
  end

  describe "DELETE /soft_delete" do
    it "render a successful response to soft_delete a store" do
      delete "/products/#{products[0].id}",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_seller["token"]}",
        "Content-Type" => "application/json"
      }
      json = JSON.parse(response.body)
      puts json
      expect(json).to eq true
    end
  end
end
