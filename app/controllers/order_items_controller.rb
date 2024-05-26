class OrderItemsController < ApplicationController
  skip_forgery_protection
  before_action :order_item_params, only: :create
  before_action :set_order_item, only: [ :edit, :update ]
  before_action :set_order_item_update, only: [ :edit, :update ]

  def index
    @order_item = OrderItem.all
    render json: @order_item
  end

  def edit
  end

  def create
    @order_item = OrderItem.find_or_create_by(order_item_params)
    @order_item.price = @order_item.product.price * @order_item.amount

    if @order_item.save
      render json: @order_item, status: :created
    else
      render json: @order_item.errors, status: :unprocessable_entity
    end
  end

  def update
    @order_item.assign_attributes(order_item_params)
    @order_item.price = @order_item.product.price * @order_item.amount
    if @order_item.save
      redirect_to listing_orders_path, notice: "Pedido atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def order_item_params
    params.required(:order_item).permit(:order_id, :product_id, :amount, :price)
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def set_order_item_update
    @products = Store.find(@order_item.order.store_id).products
  end

end
