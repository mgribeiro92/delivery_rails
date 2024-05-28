require 'rails_helper'

RSpec.describe "orders/listing", type: :view do
  let(:orders) { create_list(:order, 2) }

  before do
    assign(:orders, orders)
  end

  it "renders a list of stores" do
    render
    orders.each do |order|
      assert_select '.card-order .order-info', text: /Pedido: #{order.id}/
      assert_select '.card-order .order-info', text: /Usuario: #{order.buyer.email}/
      assert_select '.card-order .order-info', text: /Loja: #{order.store.name}/
      assert_select '.card-order .order-info', text: /Valor Total: #{order.total}/
      assert_select '.card-order .order-item-info', text: /Estado do Pedido: #{order.state}/
    end
  end
end
