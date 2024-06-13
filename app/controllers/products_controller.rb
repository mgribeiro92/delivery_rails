class ProductsController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!
  before_action :set_product, only: %i[ show update destroy edit ]
  before_action :set_product_create, only: [ :new, :create ]
  before_action :set_product_update, only: [ :edit, :update]
  rescue_from User::InvalidToken, with: :not_authorized

  def index
    respond_to do |format|
      format.json do
        if buyer?
          if params[:query].present?
            page = params.fetch(:page, 1)
            @products = Product.where(store_id: params[:store_id])
              .where("LOWER(title) LIKE ?", "%#{params[:query]}%")
              .order(:title)
              .page(page)
              .includes(:image_product_attachment
            )
          else
            page = params.fetch(:page, 1)
            @products = Product.where(store_id: params[:store_id])
              .order(:title).page(page)
              .includes(:image_product_attachment
            )
          end
        end
      end
    end
  end

  def products_store
    page = params.fetch(:page, 1)
    @store = Store.find(params[:store_id])
    if params[:filter].present?
      @products = @store.products.where(category: params[:filter]).page(page).includes(:image_product_attachment)
    else
      @products = @store.products.page(page).includes(:image_product_attachment)
    end
  end

  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permisson for you!"
    end

    @products = Product.includes(:store).order(id: :desc)
    @products.each do |product|
      puts(product.store, product.id)
    end
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html { redirect_to listing_path, notice: "Produto criado com sucesso"}
        format.json { render json: @product, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity}
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
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
      params.required(:product).permit(:title, :price, :store_id, :image_product, :description, :inventory, :category)
    end

    def set_product_create
      @product = Product.new
      if current_user.admin?
        @stores = Store.all
      end
    end

    def set_product_update
      @stores = Store.all
    end
end
