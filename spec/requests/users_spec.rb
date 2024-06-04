require 'rails_helper'

RSpec.describe "Users", type: :request do

  let(:admin) { create(:user_admin) }

  let(:valid_attributes) {
    { email: "seller@example.com", role: "seller" }
  }

  let(:invalid_attributes) {
    { email: nil, role: nil}
  }

  before { sign_in(admin) }

  describe "GET /index" do
    it "renders a successful response" do
      post users_url, params: { user: valid_attributes }
      user = User.last
      get users_url
      expect(response).to be_successful
    end
  end


  describe "GET /show" do
    it "renders a successful response" do
      post users_url, params: { user: valid_attributes }
      user = User.last
      get user_url(user)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_user_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      post users_url, params: { user: valid_attributes }
      user = User.last
      get edit_user_url(user)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post users_url, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end

      it "redirects to the user" do
        post users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect {
          post users_url, params: { user: invalid_attributes }
        }.to change(User, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post users_url, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {email: "buyer@example.com", role: "buyer"}
      }

      it "updates the requested user" do
        post users_url, params: { user: valid_attributes }
        user = User.last
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(user.email).to eq "buyer@example.com"
        expect(user.role).to eq "buyer"
      end

      it "redirects to user" do
        post users_url, params: { user: valid_attributes }
        user = User.last
        patch user_url(user), params: { user: new_attributes }
        user.reload
        expect(response).to redirect_to(user_url(user))
      end
    end

    context "with invalid parameters" do

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        post users_url, params: { user: valid_attributes }
        user = User.last
        patch user_url(user), params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested user" do
      post users_url, params: { user: valid_attributes }
      user = User.last
      expect { delete store_url(user) }.to change(User, :count).by(0)
    end

    it "redirects to the user" do
      post users_url, params: { user: valid_attributes }
      user = User.last
      delete user_url(user)
      expect(response).to redirect_to(user_url(user))
    end

    it "user change this status" do
      post users_url, params: { user: valid_attributes }
      user = User.last
      delete user_url(user)
      user.reload
      expect(user.soft_delete).to eq(true)
    end
  end

end
