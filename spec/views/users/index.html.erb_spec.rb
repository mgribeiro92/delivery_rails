require 'rails_helper'

RSpec.describe "users/index", type: :view do
  let(:users) { create_list(:user_seller, 3) }

  before do
    assign(:users, users)
  end

  it "renders a list of users" do
    render
    users.each do |user|
      assert_select 'tr>td', text: /#{user.id}/
      assert_select 'tr>td', text: /#{user.email}/
      assert_select 'tr>td', text: /#{user.role}/
      assert_select 'tr>td', text: /#{user.status}/
    end
  end
end
