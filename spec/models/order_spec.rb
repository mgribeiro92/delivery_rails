require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "validations" do
    it { should belong_to(:buyer) }
    it { should belong_to(:store) }
  end

  describe "belongs_to" do
    let(:seller) {
    user = User.new(
      email: "buyer@example.com.br",
      password: "123456",
      password_confirmation: "123456",
      role: "seller"
      )
    }

    let(:buyer) {
    user = User.new(
      email: "buyer@example.com.br",
      password: "123456",
      password_confirmation: "123456",
      role: "buyer"
      )
    }

    let(:store) {
      store = Store.new(
        name: "What a great store!",
        user: seller
      )
    }

    it "should belongs to buyer user" do
      order = Order.create(buyer: buyer, store: store)

      expect(order).to be_persisted
    end

    it "should not belongs to seller user" do
      order = Order.create(buyer: seller, store: store)

      expect(order.errors.full_messages).to eq ["Buyer should be a 'user.buyer'"]
    end
  end
end
