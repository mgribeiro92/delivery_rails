require "rails_helper"

RSpec.describe "/orders", type: :request do

  let(:seller) { create(:user_seller) }
  let(:buyer_1) { create(:user_buyer)}
  let(:buyer_2) { create(:user_buyer)}
  let(:store_1) { create(:store, user: seller) }
  let(:store_2) { create(:store, user: seller) }
  let(:product) { create(:product, store: store_1) }

  let!(:orders) do
    buyer_1_orders_store_1 = create_list(:order, 2, store: store_1, buyer: buyer_1)
    buyer_1_orders_store_2 = create_list(:order, 2, store: store_2, buyer: buyer_1)
    buyer_2_orders_store_1 = create_list(:order, 2, store: store_1, buyer: buyer_2)
    buyer_2_orders_store_2 = create_list(:order, 2, store: store_2, buyer: buyer_2)

    buyer_1_orders_store_1 + buyer_1_orders_store_2 + buyer_2_orders_store_1 + buyer_2_orders_store_2
  end

  let(:valid_attributes) {
    {store_id: store_1.id, buyer_id: buyer.id, order_items_attributes: [product_id: product.id, amount: 4] }
  }

  let(:invalid_attributes) {
    {buyer_id: buyer.id, order_items_attributes: [product_id: product.id, amount: 4] }
  }

  let(:credential_seller) { Credential.create_access(:seller) }
  let(:credential_buyer) { Credential.create_access(:buyer) }

  let(:signed_in_seller) { api_sign_in(seller, credential_seller )}
  let(:signed_in_buyer) { api_sign_in(buyer_1, credential_buyer )}

  describe "GET /index" do
    it "render a successful response with current_user buyer to this orders" do
      get "/buyers/orders",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{signed_in_buyer["token"]}",
        "X-API-KEY" => credential_buyer.key
      }
      json = JSON.parse(response.body)
      order_ids = json.map { |order| order["id"] }
      expected_order_ids = orders.select { |order| order.buyer == buyer_1 }.map(&:id)

      expect(order_ids).to match_array(expected_order_ids)
    end
  end
end
