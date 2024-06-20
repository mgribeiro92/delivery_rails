require 'rails_helper'

RSpec.describe "orders/edit", type: :view do

  let(:admin) { create(:user_admin) }
  let(:buyers) {create_list(:user_buyer, 3)}
  let(:stores) { create_list(:store, 3) }
  let(:order) { create(:order) }

  before do
    assign(:stores, stores)
    assign(:buyers, buyers)
    assign(:order, order)
    render
  end

  describe "when the current user is an admin" do
    before do
      allow(view).to receive(:current_user).and_return(admin)
    end

    it "displays all the stores and buyers" do
      stores.each do |store|
        expect(rendered).to match(store.name)
      end
      buyers.each do |buyer|
        expect(rendered).to match(buyer.email)
      end
    end
  end

  it "renders the edit product form" do
    render

    assert_select "form[action=?][method=?]", order_path(order), "post" do
      assert_select "select[name=?]", "order[buyer_id]"
      assert_select "select[name=?]", "order[store_id]"
      assert_select "select[name=?]", "order[state]"
    end
  end
end
