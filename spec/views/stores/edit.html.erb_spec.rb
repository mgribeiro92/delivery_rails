require 'rails_helper'

RSpec.describe "stores/edit", type: :view do
  let(:user) { create(:user_seller) }

  let(:store) {
    Store.create!(
      name: "MyString",
      user: user
    )
  }

  before(:each) do
    assign(:store, store)
  end

  before do
    sign_in user
  end

  it "renders the edit store form" do
    render

    assert_select "form[action=?][method=?]", store_path(store), "post" do

      assert_select "input[name=?]", "store[name]"
    end
  end
end
