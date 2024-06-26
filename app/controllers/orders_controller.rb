class OrdersController < ApplicationController
  skip_forgery_protection
  before_action :set_order, only: [ :show, :edit, :update ]
  before_action :authenticate!
  before_action :only_buyers!, only: [ :index ]
  before_action :set_order_update, only: [ :edit, :update ]
  before_action :set_order_create, only: %i[ new create]

  rescue_from StateMachines::InvalidTransition, with: :invalid_transition

  def index
    @orders = Order.where(buyer: current_user).includes(:buyer, :store, order_items: :product).order(id: :desc)
  end

  def listing
    if current_user.admin?
      @orders = Order.all.includes(:buyer, :store, order_items: :product).order(id: :desc)
    end
  end

  def sellers
    @store = Store.find(params[:id])
    if current_user.stores.include?(@store)
      @orders = Order.where(store: @store).order(id: :desc).includes(:store, :buyer, order_items: :product)
    else
      render json: {message: "Store not include to user"}
    end
  end

  def payment
    PaymentJob.perform_later(
      order: payment_params[:order_id],
      value: payment_params[:value],
      number: payment_params[:number],
      valid: payment_params[:valid],
      cvv: payment_params[:cvv]
    )

    render json: { message: 'Payment processing' }, status: :accepted
  end

  def show
  end

  def edit
  end

  def new
    @order = Order.new
  end

  def create
    if request.format.json?
      @order = Order.new(order_params) { |o| o.buyer = current_user }
    else
      @order = Order.new(order_params)
    end

    @order.total = 0
    respond_to do |format|
      if @order.save
        format.html { redirect_to new_order_item_path(order_id: @order.id), notice: "Pedido criado com sucesso, pode colocar os produtos!"}
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @order.errors }
      end
    end
  end

  def update
    if @order.update(order_params)
      redirect_to order_url(@order), notice: "Pedido atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
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

  # def status_order
  #   response.headers['Content-Type'] = 'text/event-stream'
  #   sse = SSE.new(response.stream, retry: 300, event: "status-order")

  #   order = Order.find(params[:order_id])
  #   last_order = order.state

  #   EventMachine.run do
  #     EventMachine::PeriodicTimer.new(3) do
  #       order.reload
  #       puts("EVENT MACHINE")
  #       puts(last_order)
  #       puts(order.state)
  #       if order.state != last_order
  #         # response.stream.write("event: status_update\ndata: #{@order.state}\n\n")
  #         sse.write({order: "pedido atualizado"}, event: "new-status")
  #         puts("MUDAR STATUS")
  #         # last_order = order.state
  #       end
  #     end
  #   end

  # rescue IOError, ActionController::Live::ClientDisconnected
  #   sse.close
  # ensure
  #   sse.close
  # end


  private

  def set_order
    @order = Order.includes(order_items: :product).find(params[:id])
  end

  def order_params
    params.require(:order).permit(:store_id, :buyer_id, :state, order_items_attributes: [:product_id, :amount])
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

  def set_order_create
    if current_user.admin?
      @stores = Store.all
      @buyers = User.where(role: :buyer)
    end
  end

  def payment_params
    params.require(:payment).permit(:order_id, :value, :number, :valid, :cvv)
  end

end
