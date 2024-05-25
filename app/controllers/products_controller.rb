class ProductsController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!
  before_action :set_product, only: %i[ show update destroy edit ]
  rescue_from User::InvalidToken, with: :not_authorized

  def index
    respond_to do |format|
      format.json do
        if buyer?
          page = params.fetch(:page, 1)
          @products = Product.where(store_id: params[:store_id]).order(:title).page(page).includes(:image_product_attachment)
        end
      end
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

  def new
    @product = Store.new
    if current_user.admin?
      @stores = Store.all
    end
  end

  def edit
    if current_user.admin?
      @stores = Store.all
    end
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
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to store_url(@product.store), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if current_user.admin?
      if @product.update(soft_delete: !@product.soft_delete)
        redirect_to product_url(@product), notice: "Produto #{@product.title} foi mudado seu status para #{@product.status}!"
      end
    end
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
