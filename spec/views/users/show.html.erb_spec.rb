require 'rails_helper'

RSpec.describe "users/show", type: :view do

  let(:user) { create(:user1) }

  before do
    assign(:user, user)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/user@example.com/)
  end
end
