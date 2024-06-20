require 'rails_helper'

RSpec.describe ProductsController, type: :request do

  let(:buyer) { create(:user_buyer) }
  let(:seller) { create(:user_seller) }

  let(:store) { create(:store) }
  let!(:products) { create_list(:product, 5, store: store) }

  let(:valid_attributes) {
    { title: "X-Salada", store_id: store.id, price: 22, inventory: 20 }
  }

  let(:credential_seller) { Credential.create_access(:seller) }
  let(:credential_buyer) { Credential.create_access(:buyer) }

  let(:signed_in_seller) { api_sign_in(seller, credential_seller )}
  let(:signed_in_buyer) { api_sign_in(buyer, credential_buyer )}

  describe 'GET #index' do
    it 'renders a successful response' do
      get "/stores/#{store.id}/products",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_buyer["token"]}",
        "X-API-KEY" => credential_buyer.key
      }
      json = JSON.parse(response.body)
      products_api = json.dig("result", "products")
      products_title = products_api.map { |product| product["title"] }
      
      expect(products_title).to match_array(products.map(&:title))
    end
  end

  describe "GET /show" do
    it "render a successful response with product data" do
      product = Product.create! valid_attributes
      get "/products/#{product.id}",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_seller["token"]}"
      }
      json = JSON.parse(response.body)
      expect(json["product"]["title"]).to eq "X-Salada"
    end
  end

  describe "POST /create" do
    it "render a successful response to create a new product" do
      post "/products",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_seller["token"]}",
        "Content-Type" => "application/json"
      },
      params: valid_attributes.to_json
      json = JSON.parse(response.body)

      expect(json["product"]["title"]).to eq "X-Salada"
    end
  end

  describe "PATCH /update" do
    it "render a successful response to update a product" do
      patch "/products/#{products[0].id}",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_seller["token"]}",
        "Content-Type" => "application/json"
      },
      params: valid_attributes.to_json
      json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(json["product"]["title"]).to eq "X-Salada"
    end
  end

  # describe "DELETE /soft_delete" do
  #   it "render a successful response to soft-delete a store" do
  #     delete "/products/#{products[0].id}",
  #     headers: {
  #       "Accept" => "application/json",
  #       "Authorization" => "Bearer #{signed_in_seller["token"]}",
  #       "Content-Type" => "application/json"
  #     }
  #     puts response.body
  #     json = JSON.parse(response.body)
  #     expect(json).to eq true
  #   end
  # end
end
