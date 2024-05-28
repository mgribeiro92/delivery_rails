require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validations" do
    it { should belong_to(:buyer) }
    it { should belong_to(:store) }
  end

  describe "belongs_to" do
    let(:buyer) { create(:user_buyer) }
    let(:seller) { create(:user_seller) }
    let(:store) { create(:store) }

    it "should belongs to buyer user" do
      order = Order.create(buyer: buyer, store: store)
      puts(order.buyer.role)

      expect(order.buyer).to be_buyer
    end

    it "should not belongs to seller user" do
      order = Order.create(buyer: seller, store: store)

      expect(order.errors.full_messages).to eq ["Buyer should be a 'user.buyer'"]
    end
  end
end
