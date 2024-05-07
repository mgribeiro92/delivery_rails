class ProductsController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!
  before_action :set_product, only: %i[ show update ]

  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permisson for you!"
    end

    @products = Product.includes(:store)
  end

  def show
    render json: {product: @product}
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.required(:product).permit(:title, :price, :store_id)
    end
end
