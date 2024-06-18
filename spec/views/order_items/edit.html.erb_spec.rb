require 'rails_helper'

RSpec.describe "order_items/edit", type: :view do

  let(:store) { create(:store) }
  let(:products) { create_list(:product, 3, store: store) }
  let(:order) { create(:order, store: store)}
  let(:order_item) { build(:order_item, order: order, product: products.first) }

  before do
    assign(:products, products)
    assign(:order_item, order_item)
    assign(:order, order)
    render
  end

  describe "render the form and the products" do

    it "displays all the products" do
      products.each do |product|
        expect(rendered).to match(product.title)
      end
    end

    it "displays the order information" do
      expect(rendered).to match(order_item.order.id.to_s)
      expect(rendered).to match(order_item.order.store.name)
    end

    it "renders the edit order_item form" do
      assert_select "form[action=?][method=?]", order_item_path(order_item), "post" do
        assert_select "input[name=?]", "order_item[amount]"
        assert_select "select[name=?]", "order_item[product_id]"
      end
    end

  end
end
