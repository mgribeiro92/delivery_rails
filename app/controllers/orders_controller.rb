class OrdersController < ApplicationController
  skip_forgery_protection
  before_action :set_order, only: [ :show, :edit, :update ]
  before_action :authenticate!
  before_action :only_buyers!, only: [ :index, :create ]
  before_action :set_order_update, only: %i[ edit update ]
  rescue_from StateMachines::InvalidTransition, with: :invalid_transition

  def index
    @orders = Order.where(buyer: current_user).includes(:buyer, :store, order_items: :product).order(id: :desc)
  end

  def listing
    if current_user.admin?
      @orders = Order.all.includes(:buyer, :store, order_items: :product).order(id: :desc)
    end
  end

  def show
  end

  def edit
  end

  def create
    @order = Order.new(order_params) { |o| o.buyer = current_user }

    if @order.save
      render json: @order
    else
      render json: {errors: @order.errors, status: :unprocessable_entity}
    end
  end

  def update
    if @order.update(order_params)
      redirect_to listing_orders_path, notice: "Pedido atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def sellers
    @store = Store.find(params[:id])

    if current_user.stores.include?(@store)
      @orders = Order.where(store: @store).order(id: :desc)
    else
      render json: {message: "Store not include to user"}
    end
  end

  def change_state
    @order = Order.find(params[:order][:id])
    state = params[:order][:state]

    event_method =
    case state
      when 'accept' then :accept!
      when 'delivery' then :delivery!
      when 'finished' then :finished!
      when 'rejected' then :rejected!
      else nil
    end

    if event_method && @order.send(event_method)
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:store_id, :buyer_id, :total, :state)
  end

  def invalid_transition(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def set_order_update
    if current_user.admin?
      @buyers = User.where(role: :buyer)
      @stores = Store.all
      @products = @order.store.products
    end
  end

end
