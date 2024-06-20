require 'rails_helper'

RSpec.describe "stores/index", type: :view do
  let(:user) { create(:user_seller) }
  let(:stores) {create_list(:store, 2)}

  before(:each) do
    assign(:stores, [
      Store.create!(
        name: "Name",
        user: user
      ),
      Store.create!(
        name: "Name",
        user: user
      )
    ])
  end

  it "renders a list of stores" do
    render
    cell_selector = 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
  end
end
