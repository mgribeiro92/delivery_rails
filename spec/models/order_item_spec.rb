require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "validations" do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end

  describe "belongs to" do

    let(:stores) { create(:store) }
    let(:product2) { create(:product2) }

    # let(:store2) { create(:store, user: seller ) }
    # let(:product2) { create(:product2, store: store2) }

    let(:order) { create(:order) }

    it "product should belongs to store" do
      order_item = OrderItem.create(order: order, product: product2, amount: 2, price: product2)

      expect(order_item.errors.full_messages).to eq ["Order should belong to 'Store': #{order.store.name}"]
    end
  end
end
