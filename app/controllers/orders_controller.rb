class OrdersController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!
  before_action :only_buyers!, only: [ :index, :create]
  rescue_from StateMachines::InvalidTransition, with: :invalid_transition

  def index
    @orders = Order.where(buyer: current_user)
  end

  def create
    @order = Order.new(order_params) { |o| o.buyer = current_user }

    if @order.save
      render json: @order
    else
      render json: {errors: @order.errors, status: :unprocessable_entity}
    end
  end

  def sellers
    @store = Store.find(params[:id])

    if current_user.stores.include?(@store)
      @orders = Order.where(store: @store)
      render json: @orders
    else
      render json: {message: "Store not include to user"}
    end
  end

  def accept
    @order = Order.find(params[:id])

    if @order.accept!
      render json: @order
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit([:store_id])
  end

  def invalid_transition(e)
    render json: { error: e.message }, status: :unprocessable_entity
  end

end
