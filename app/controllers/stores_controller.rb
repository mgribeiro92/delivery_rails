class StoresController < ApplicationController
  skip_forgery_protection only: [ :create, :update, :destroy ]
  before_action :authenticate!
  before_action :set_store, only: %i[ show edit update destroy ]
  rescue_from User::InvalidToken, with: :not_authorized

  # GET /stores or /stores.json
  def index
    if current_user.admin?
      @stores = Store.all
    else
      @stores = Store.where(user: current_user)
    end
  end

  # GET /stores/1 or /stores/1.json
  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: {store: @store, products: @store.products} }
    end
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
    if current_user.admin?
      @sellers = User.where(role: :seller)
    end
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
    @store.destroy!

    respond_to do |format|
      format.html { redirect_to stores_url, notice: "Store was successfully destroyed." }
      format.json { render json: {message: "Store destroyed!"} }
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
        required.permit(:name, :user_id)
      else
        required.permit(:name)
      end
    end
end
