require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "validations" do
    it { should belong_to(:order) }
    it { should belong_to(:product) }
  end

  describe "belongs to" do
    let(:store_1) {
      store = Store.new(
        name: "Pizzaria"
      )
    }

    let(:store_2) {
      store = Store.new(
        name: "Hot Dog"
      )
    }

    let(:product_1) {
      product = Product.new(
        store: store_1,
        title: "Pizza Calabresa",
        price: 35
      )
    }

    let(:product_2) {
      product = Product.new(
        store: store_1,
        title: "Hot Dog Simples",
        price: 15
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

    let(:order) {
      order = Order.new(
        buyer: buyer,
        store: store_1,
      )
    }

    it "product should belongs to store" do
      order_item = OrderItem.create(order: order, product: product_2, amount: 2, price: product_2.price)

      expect(order_item.errors.full_messages).to eq ["Product should belong to 'Store': #{order.store.name}"]
    end
  end
end
