class OrderItemsController < ApplicationController
  skip_forgery_protection
  before_action :order_item_params, only: :create

  def index
    @order_item = OrderItem.all
    render json: @order_item
  end

  def create
    @order_item = OrderItem.find_or_create_by(order_item_params)
    # @order_item.price = @order_item.product.price * @order_item.amount

    if @order_item.save
      render json: @order_item, status: :created
    else
      render json: @order_item.errors, status: :unprocessable_entity
    end

  end

  private

  def order_item_params
    params.required(:order_item).permit(:order_id, :product_id, :amount, :price)
  end

end
