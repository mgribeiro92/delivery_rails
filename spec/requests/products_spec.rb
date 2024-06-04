require 'rails_helper'

RSpec.describe "Products", type: :request do
  
  let(:admin) { create(:user_admin) }
  let(:store) { create(:store) }

  let(:valid_attributes) {
    { title: "Pizza Marguerita", price: 40, store_id: store.id }
  }

  let(:invalid_attributes) {
    { title: nil}
  }

  before { sign_in(admin) }

  describe "GET /show" do
    it "renders a successful response" do
      product = Product.create! valid_attributes
      get product_url(product)
      expect(response).to be_successful
    end
  end

  describe "GET /listing" do
    it "render a successful response" do
      get listing_url
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_product_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      product = Product.create! valid_attributes
      get edit_product_url(product)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Product" do
        expect {
          post products_url, params: { product: valid_attributes }
        }.to change(Product, :count).by(1)
      end

      it "redirects to the listing products" do
        post products_url, params: { product: valid_attributes }
        expect(response).to redirect_to(listing_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Product" do
        expect {
          post products_url, params: { product: invalid_attributes }
        }.to change(Product, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post products_url, params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        {title: "Pizza 4 Queijos"}
      }

      it "updates the requested product" do
        product = Product.create! valid_attributes
        patch product_url(product), params: { product: new_attributes }
        product.reload
        expect(product.title).to eq "Pizza 4 Queijos"
      end

      it "redirects to the store of product" do
        product = Product.create! valid_attributes
        patch product_url(product), params: { product: new_attributes }
        product.reload
        expect(response).to redirect_to(store_url(product.store))
      end
    end

    context "with invalid parameters" do

      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        product = Product.create! valid_attributes
        patch product_url(product), params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested product" do
      product = Product.create! valid_attributes
      expect { delete product_url(product) }.to change(Store, :count).by(0)
    end

    it "redirects to the product" do
      product = Product.create! valid_attributes
      delete product_url(product)
      expect(response).to redirect_to(product_url(product))
    end

    it "product change this status" do
      product = Product.create! valid_attributes
      delete product_url(product)
      product.reload
      expect(product.soft_delete).to eq(true)
    end
  end

end
