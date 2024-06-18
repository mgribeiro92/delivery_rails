require 'rails_helper'

RSpec.describe "OrderItems", type: :request do

  let(:admin) { create(:user_admin) }
  let(:store) { create(:store) }
  let(:product) { create(:product, store: store) }
  let(:order) { create(:order, store: store) }

  let(:valid_attributes) {
    { order_id: order.id, price: product.price, product_id: product.id, amount: 4}
  }

  let(:invalid_attributes) {
    { order_id: order.id, product_id: product.id, amount: nil }
  }

  before { sign_in(admin) }

  describe "GET /index" do
    it "renders a successful response" do
      OrderItem.create! valid_attributes
      get order_items_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      order_item = OrderItem.create! valid_attributes
      get edit_order_item_url(order_item, order_id: order_item.order)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new order item" do
        expect {
          post order_items_url, params: { order_item: valid_attributes }
        }.to change(OrderItem, :count).by(1)
        puts response.body
      end

      it "redirects to the edit order" do
        post order_items_url, params: { order_item: valid_attributes }
        order_item = OrderItem.last
        expect(response).to redirect_to(edit_order_path(order_item.order.id))
      end
    end

    context "with invalid parameters" do
      it "does not create a new order item" do
        expect {
          post order_items_url, params: { order_item: invalid_attributes }
        }.to change(OrderItem, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post order_items_url, params: { order_item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {amount: 5}
      }

      it "updates the requested store" do
        order_item = OrderItem.create! valid_attributes
        patch order_item_url(order_item, order_id: order_item.order), params: { order_item: new_attributes }
        order_item.reload
        expect(order_item.amount).to eq 5
        expect(order_item.price).to eq order_item.product.price * 5
      end

      it "redirects to the order" do
        order_item = OrderItem.create! valid_attributes
        patch order_item_url(order_item, order_id: order_item.order), params: { order_item: new_attributes }
        order_item.reload
        expect(response).to redirect_to(edit_order_path(order_item.order.id))
      end
    end

    context "with invalid parameters" do

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        order_item = OrderItem.create! valid_attributes
        patch order_item_url(order_item, order_id: order_item.order), params: { order_item: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested order item" do
      order_item = OrderItem.create! valid_attributes
      expect { delete order_item_url(order_item) }.to change(OrderItem, :count).by(-1)
    end

    it "redirects to the order item" do
      order_item = OrderItem.create! valid_attributes
      delete order_item_url(order_item)
      expect(response).to redirect_to(edit_order_path(order_item.order))
    end
  end
end
