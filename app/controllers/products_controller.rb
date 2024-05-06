class ProductsController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!
  before_action :product_params, only: %i[ create ]

  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permisson for you!"
    end

    @products = Product.includes(:store)
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

    def product_params
      params.required(:product).permit(:title, :price, :store_id)
    end
end
