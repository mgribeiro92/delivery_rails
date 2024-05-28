require 'rails_helper'

RSpec.describe "products/new", type: :view do

  let(:admin) { create(:user_admin) }
  let(:stores) { create_list(:store, 3) }
  let(:product) { create(:product) }

  before do
    assign(:stores, stores)
    assign(:product, product)
    render
  end

  describe "when the current user is an admin" do
    before do
      allow(view).to receive(:current_user).and_return(admin)
    end

    it "displays all the stores" do
      stores.each do |store|
        expect(rendered).to match(store.name)
      end
    end
  end

  it "renders the new product form" do
    render

    assert_select "form[action=?][method=?]", product_path(product), "post" do
      assert_select "input[name=?]", "product[title]"
      assert_select "input[name=?]", "product[price]"
      assert_select "select[name=?]", "product[store_id]"
    end
  end
end
