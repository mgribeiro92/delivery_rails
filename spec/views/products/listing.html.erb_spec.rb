require 'rails_helper'

RSpec.describe "products/listing", type: :view do
  let(:products) { create_list(:product, 4) }

  before do
    assign(:products, products)
  end

  it "renders a list of products" do
    render
    products.each do |product|
      assert_select 'tr>td', text: /#{product.title}/
      assert_select 'tr>td', text: /#{product.store.name}/
      assert_select 'tr>td', text: /#{product.price}/
      assert_select 'tr>td', text: /#{product.status}/
    end
  end

end
