require "rails_helper"

RSpec.describe "/stores", type: :request do

  let(:seller_1) { create(:user_seller) }
  let(:seller_2) { create(:user_seller) }
  let(:buyer) { create(:user_buyer)}
  let!(:stores) do
    seller1_active_stores = create_list(:store, 5, user: seller_1, soft_delete: false)
    seller2_active_stores = create_list(:store, 5, user: seller_2, soft_delete: false)

    seller1_deleted_stores = create_list(:store, 2, user: seller_1, soft_delete: true)
    seller2_deleted_stores = create_list(:store, 2, user: seller_2, soft_delete: true)

    seller1_active_stores + seller2_active_stores + seller1_deleted_stores + seller2_deleted_stores
  end

  let(:valid_attributes) {
    {name: "New Store", user_id: seller_1.id }
  }

  let(:invalid_attributes) {
    {name: nil}
  }

  let(:credential_seller) { Credential.create_access(:seller) }
  let(:credential_buyer) { Credential.create_access(:buyer) }

  let(:signed_in_seller) { api_sign_in(seller_1, credential_seller )}
  let(:signed_in_buyer) { api_sign_in(buyer, credential_buyer )}


  describe "GET /index" do
    it "render a successful response with current_user seller to this stores with soft_delete = false" do
      get "/stores",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_seller["token"]}"
      }
      json = JSON.parse(response.body)
      store_names = json['stores'].map { |store| store['name'] }
      seller1_active_store_names = seller_1.stores.where(soft_delete: false).pluck(:name)

      expect(store_names).to match_array(seller1_active_store_names)
    end

    it "render a successful response with current_user buyer to all stores with soft_delete = false" do
      get "/stores",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_buyer["token"]}"
      }
      json = JSON.parse(response.body)
      active_store_names = Store.where(soft_delete: false).pluck(:name)
      store_names = json["stores"].map { |store| store["name"] }

      expect(store_names).to match_array(active_store_names)
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
      params: valid_attributes.to_json
      puts response.body
      json = JSON.parse(response.body)

      expect(json["name"]).to eq "New Store"
      expect(json["user_id"]).to eq seller_1.id
    end
  end

  describe "PATCH /update" do
    it "render a successful response to update a store" do
      store = Store.create! valid_attributes
      patch "/stores/#{store.id}",
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
      store = Store.create! valid_attributes
      delete "/stores/#{store.id}",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_seller["token"]}",
        "Content-Type" => "application/json"
      }
      json = JSON.parse(response.body)

      expect(json).to include('message' => 'Loja e seus produtos desativados!')
      expect(store.reload.soft_delete).to eq(true)

      store.products.each do |product|
        expect(product.reload.soft_delete).to eq(true)
      end
    end
  end
end
