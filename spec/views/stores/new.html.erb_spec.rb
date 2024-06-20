require 'rails_helper'

RSpec.describe "stores/new", type: :view do
  let(:admin) { create(:user_admin)}
  let(:sellers) { create_list(:user_seller, 3) }

  before(:each) do
    assign(:store, Store.new(
      name: "MyString"
    ))
  end

  before do
    assign(:sellers, sellers)
    sign_in admin
  end




  it "renders new store form" do
    render

    assert_select "form[action=?][method=?]", stores_path, "post" do

      assert_select "input[name=?]", "store[name]"
    end
  end
end
