class OrderItemsController < ApplicationController
  skip_forgery_protection
  before_action :order_item_params, only: [ :update, :create ]
  before_action :set_order_item, only: [ :edit, :update, :destroy ]
  before_action :set_order_item_update, only: [ :edit, :update ]
  before_action :set_order_item_create, only: [ :new, :create ]
  # before_action :set_order, only: [ :new, :edit, :create, :update ]

  def index
    @order_item = OrderItem.all
    render json: @order_item
  end

  def edit
  end

  def new
  end

  def create
    @order_item = OrderItem.new(order_item_params.merge(order: @order))
    respond_to do |format|
      if @order_item.save
        format.html { redirect_to edit_order_path(@order_item.order), notice: "Produto adicionado com sucesso!"}
        format.json { render json: @order_item, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @order_item.update(order_item_params)
      redirect_to edit_order_path(@order_item.order), notice: "Pedido atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    redirect_to edit_order_path(@order_item.order), notice: 'Produto removido do pedido com sucesso!'
  end

  private

  def order_item_params
    params.required(:order_item).permit(:order_id, :product_id, :amount)
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def set_order_item_update
    set_order
    @products = Store.find(@order_item.order.store_id).products
    # @order = @order_item.order_id
  end

  def set_order_item_create
    set_order
    @order_item = OrderItem.new()
    @products = Store.find(@order.store.id).products
  end

  def set_order
    order_id = params[:order_id] || params.dig(:order_item, :order_id)
    @order = Order.find(order_id)
  rescue ActiveRecord::RecordNotFound
    @order = nil
    respond_to do |format|
      format.html { render :new, status: :not_found }
      format.json { render json: { error: 'Order not found' }, status: :not_found }
    end
  end

end
