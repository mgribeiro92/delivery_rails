require 'rails_helper'

RSpec.describe "order_items/new", type: :view do

  let(:buyers) { create_list(:user_buyer, 3) }
  let(:products) { create_list(:product, 3) }
  let(:stores) { create_list(:store, 3) }
  let(:order_item) { create(:order_item) }

  before do
    assign(:products, products)
    assign(:order_item, order_item)
    assign(:order, order_item.order)
    assign(:buyers, buyers)
    assign(:stores, stores)
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
