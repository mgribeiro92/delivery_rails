require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "validations" do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end

  describe "belongs to" do

    let(:store) { create(:store) }
    let(:product) { create(:product, store: store) }
    let(:order) { create(:order, store: store) }

    it 'product should belong to the same store as the order' do
      order_item = OrderItem.create(order: order, product: product, amount: 2, price: product.price)

      expect(order_item.errors.full_messages).to be_empty
      expect(order_item.product.store).to eq(order.store)
    end
    it 'should not create order_item if product store and order store do not match' do
      another_store = create(:store)
      order_from_another_store = create(:order, store: another_store)

      order_item = OrderItem.create(order: order_from_another_store, product: product, amount: 2, price: product.price)

      expect(order_item.errors.full_messages).to include("Order should belong to 'Store': #{another_store.name}")
    end
  end
end
