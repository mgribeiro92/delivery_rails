require 'rails_helper'

RSpec.describe "Orders", type: :request do

  let(:admin) { create(:user_admin) }
  let(:store) { create(:store) }
  let(:buyer) { create(:user_buyer) }
  let(:valid_attributes) {
    { store_id: store.id, buyer_id: buyer.id }
  }

  let(:invalid_attributes) {
    { store_id: nil, buyer_id: nil }
  }

  before { sign_in(admin) }

  describe "GET /edit" do
    it "renders a successful response" do
      order = Order.create! valid_attributes
      get edit_order_url(order)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new order" do
        expect {
          post orders_url, params: { order: valid_attributes }
        }.to change(Order, :count).by(1)
      end

      it "redirects to the order" do
        post orders_url, params: { order: valid_attributes }
        expect(response).to redirect_to(new_order_item_path(order_id: Order.last.id))
      end
    end

    context "with invalid parameters" do
      it "does not create a new order" do
        expect {
          post orders_url, params: { order: invalid_attributes }
        }.to change(Order, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post orders_url, params: { order: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {buyer_id: 3}
      }

      it "updates the requested store" do
        order = Order.create! valid_attributes
        patch order_url(order), params: { order: new_attributes }
        order.reload
        expect(order.buyer_id).to eq 3
      end

      it "redirects to the order" do
        order = Order.create! valid_attributes
        patch order_url(order), params: { order: new_attributes }
        order.reload
        expect(response).to redirect_to(order_url(order))
      end
    end

    context "with invalid parameters" do

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        order = Order.create! valid_attributes
        patch order_url(order), params: { order: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end
  
end
