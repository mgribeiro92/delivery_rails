class StoresController < ApplicationController
  # include ActionController::Live
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
      puts("TA PASSANDO NO BUYER")
      user = current_user
      user_coordinates = [user.address.latitude, user.address.longitude] if user.address
      if params[:query].present?
        @stores = Store.where("LOWER(name) LIKE ?", "%#{params[:query]}%").includes(:image_attachment)
        render locals: { user_coordinates: user_coordinates }
      elsif params[:filter].present?
        @stores = Store.where(category: params[:filter])
        render locals: { user_coordinates: user_coordinates }
      elsif params[:near].present?
        @stores = Store.includes(:address).map do |store|
          if store.address.present?
            distance = store.address.distance_to(user_coordinates)
          { store: store, distance: distance }
          end
        end.compact
        @stores = @stores.sort_by! { |s| s[:distance] }.map { |s| s[:store] }
        render locals: { user_coordinates: user_coordinates }

      else
        @stores = Store.includes(:image_attachment, :address).all
        render locals: { user_coordinates: user_coordinates }
      end
    else
      puts("aqui esta passando as stores do seller")
      @stores = Store.where(user: current_user).includes(:image_attachment).all
    end
  end

  def new_order
    response.headers["Content-Type"] = "text/event-stream"
    sse = SSE.new(response.stream, retry: 300, event: "waiting-orders")
    sse.write({hello: "world"}, event: "waiting-order")

    EventMachine.run do
      EventMachine::PeriodicTimer.new(3) do
        puts("EVENT MACHINE")
        order = Order.where(store_id: params[:store_id], state: :payment_success)
        if order
          sse.write({order: order}, event: "new-order")
        end
      end
    end

  rescue IOError, ActionController::Live::ClientDisconnected
    sse.close
  ensure
    sse.close
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
      puts("pasou aqui na imagem")
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
      required.permit(:name, :user_id, :image, :description, :category)
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
