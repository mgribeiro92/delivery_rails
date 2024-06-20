require 'rails_helper'

RSpec.describe "products/show", type: :view do

  let(:store) { create(:store) }

  before(:each) do
    @product = assign(:product, Product.create!(
      title: "Pizza Calabresa",
      price: 35,
      inventory: 20,
      store: store
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Pizza Calabresa/)
  end
end
