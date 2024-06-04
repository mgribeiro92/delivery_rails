require 'rails_helper'

RSpec.describe "Stores", type: :request do

  let(:user) { create(:user_seller) }

  let(:valid_attributes) {
    {name: "Greatest Restaurant", user: user}
  }

  let(:invalid_attributes) {
    {name: nil}
  }

  before { sign_in(user) }

  describe "GET /index" do
    it "renders a successful response" do
      Store.create! valid_attributes
      get stores_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      store = Store.create! valid_attributes
      get store_url(store)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_store_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      store = Store.create! valid_attributes
      get edit_store_url(store)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Store" do
        expect {
          post stores_url, params: { store: valid_attributes }
        }.to change(Store, :count).by(1)
      end

      it "redirects to the created store" do
        post stores_url, params: { store: valid_attributes }
        expect(response).to redirect_to(store_url(Store.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Store" do
        expect {
          post stores_url, params: { store: invalid_attributes }
        }.to change(Store, :count).by(0)
      end


      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post stores_url, params: { store: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {name: "greatest store"}
      }

      it "updates the requested store" do
        store = Store.create! valid_attributes
        patch store_url(store), params: { store: new_attributes }
        store.reload
        expect(store.name).to eq "greatest store"
      end

      it "redirects to the store" do
        store = Store.create! valid_attributes
        patch store_url(store), params: { store: new_attributes }
        store.reload
        expect(response).to redirect_to(store_url(store))
      end
    end

    context "with invalid parameters" do

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        store = Store.create! valid_attributes
        patch store_url(store), params: { store: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested store" do
      store = Store.create! valid_attributes
      expect { delete store_url(store) }.to change(Store, :count).by(0)
    end

    it "redirects to the store" do
      store = Store.create! valid_attributes
      delete store_url(store)
      expect(response).to redirect_to(store_url(store))
    end

    it "store change this status" do
      store = Store.create! valid_attributes
      delete store_url(store)
      store.reload
      expect(store.soft_delete).to eq(true)
    end
  end

  context "admin" do
    let(:admin) { create(:user_admin) }

    before {
      Store.create!(name: "Store 1", user: user)
      Store.create!(name: "Store 2", user: user)

      sign_in(admin)
    }

    describe "GET /index" do
      it "render a successful response" do
        get stores_url
        expect(response).to be_successful
        expect(response.body).to include "Store 1"
        expect(response.body).to include "Store 2"
      end
    end

    describe "POST /create" do
      it "creates a new Store" do
        store_attributes = {
          name: "What a great store",
          user_id: user.id
        }
        expect {
          post stores_url, params: { store: store_attributes }
        }.to change(Store, :count).by(1)

        expect(Store.find_by(name: "What a great store").user).to eq user
      end
    end
  end

end
