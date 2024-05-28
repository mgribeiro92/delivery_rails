class OrderItemsController < ApplicationController
  skip_forgery_protection
  before_action :order_item_params, only: [ :update, :create ]
  before_action :set_order_item, only: [ :edit, :update, :destroy ]
  before_action :set_order_item_update, only: [ :edit, :update ]
  before_action :set_order, only: [ :new ]

  def index
    @order_item = OrderItem.all
    render json: @order_item
  end

  def edit
  end

  def new
    @order_item = OrderItem.new()
    @products = Store.find(@order.store.id).products
  end

  def create
    @order_item_temporary = OrderItem.new(order_item_params)
    @order_item_temporary.price = @order_item_temporary.product.price * @order_item_temporary.amount
    @order_item = OrderItem.find_or_create_by(
      order_id: @order_item_temporary.order_id,
      product_id: @order_item_temporary.product_id,
      amount: @order_item_temporary.amount,
      price: @order_item_temporary.price
    )
    respond_to do |format|
      if @order_item.save
        puts('ta passando aqui')
        format.html { redirect_to edit_order_path(@order_item.order), notice: "Produto adicionado com sucesso!"}
        format.json { render json: @order_item, status: :created }
      else
        puts('ta passando no erro')
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @order_item.assign_attributes(order_item_params)
    @order_item.price = @order_item.product.price * @order_item.amount
    if @order_item.save
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
    params.required(:order_item).permit(:order_id, :product_id, :amount, :price)
  end

  def set_order_item
    @order_item = OrderItem.find(params[:id])
  end

  def set_order_item_update
    @products = Store.find(@order_item.order.store_id).products
  end

  def set_order
    @order = Order.find(params[:order_id])
  end

end
