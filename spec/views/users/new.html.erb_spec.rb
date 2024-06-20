require 'rails_helper'

RSpec.describe "users/new", type: :view do

  let(:user) { create(:user_seller) }

  before do
    assign(:user, user)
    render
  end

  describe "render the form" do

    it "renders the new user form" do
      assert_select "form[action=?][method=?]", user_path(user), "post" do
        assert_select "input[name=?]", "user[email]"
        assert_select "select[name=?]", "user[role]"
      end
    end

  end
end
