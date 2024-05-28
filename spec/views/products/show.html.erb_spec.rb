require 'rails_helper'

RSpec.describe "products/show", type: :view do

  let(:product) { create(:product2) }

  before do
    assign(:product, product)
  end
  
  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Pizza Calabresa/)
  end
end
