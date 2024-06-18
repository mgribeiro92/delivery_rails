require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      email: "user@example.com",
      role: "seller",
      password: "123456",
      password_confirmation: "123456"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/user@example.com/)
  end

end
