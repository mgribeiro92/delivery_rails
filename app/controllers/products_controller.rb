class ProductsController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!
  before_action :set_product, only: %i[ show update destroy ]
  rescue_from User::InvalidToken, with: :not_authorized

  def index
    if params[:store_id].present?
      @products = Product.where(store_id: params[:store_id])
    else
      @products = Product.all
    end
  end

  def products_store
    @store = Store.find(params[:store_id])
    @products = @store.products
  end

  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permisson for you!"
    end

    @products = Product.includes(:store)
  end

  def show
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

  def destroy
    @product.destroy!
    render json: {message: "Product destroyed!"}
  end

  private
    def not_authorized(e)
      render json: {message: "Invalid token!"}, status: 401
    end


    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.required(:product).permit(:title, :price, :store_id, :image_product)
    end
end
