class StoresController < ApplicationController
  skip_forgery_protection only: [ :create, :update, :destroy ]
  before_action :authenticate!
  before_action :set_store, only: %i[ show edit update destroy ]
  before_action :set_store_update, only: %i[ edit update ]
  rescue_from User::InvalidToken, with: :not_authorized

  # GET /stores or /stores.json
  def index
    if current_user.admin?
       @stores = Store.all.includes(:user)
    elsif current_user.buyer?
      if params[:query].present?
        puts('passando na query')
        @stores = Store.where("LOWER(name) LIKE ?", "%#{params[:query]}%").includes(:image_attachment)
       else
        @stores = Store.includes(:image_attachment).all
      end
    else
      @stores = Store.where(user: current_user).includes(:image_attachment).all
    end
  end

  def new_orders
    
  end

  # GET /stores/1 or /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
    if current_user.admin?
      @sellers = User.where(role: :seller)
    end
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores or /stores.json
  def create
    @store = Store.new(store_params)
    if !current_user.admin?
      @store.user = current_user
    end

    respond_to do |format|
      if @store.save
        format.html { redirect_to store_url(@store), notice: "Store was successfully created." }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    if store_params[:image].present?
      @store.image.attach(store_params[:image])
    end
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to store_url(@store), notice: "Store was successfully updated." }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1 or /stores/1.json
  def destroy
    respond_to do |format|
      if @store.update(soft_delete: !@store.soft_delete)
        format.html { redirect_to store_url(@store), notice: "Loja #{@store.name} foi mudado seu status para #{@store.status}!" }
        format.json { render json: @store.soft_delete }
      else
        format.html { redirect_to store_url(@store), alert: "Falha ao alterar o status da loja." }
        format.json { render json: { message: "Nope!"}}
      end
    end
  end

  private

  def not_authorized(e)
    render json: {message: "Invalid token!"}, status: 401
  end

  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    required = params.require(:store)

    if current_user.admin?
      required.permit(:name, :user_id, :image)
    else
      required.permit(:name, :image, :description, :category)
    end
  end

  def set_store_update
    if current_user.admin?
      @sellers = User.where(role: :seller)
    else
      @sellers = []
    end
  end

end
