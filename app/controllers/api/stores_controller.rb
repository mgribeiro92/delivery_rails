class Api::StoresController < ApplicationController
  before_action :set_store, only: %i[ show ]

  def index
    @stores = Store.all
    render json: @stores
  end

  def show
    @products = @store.products
    render json: { store: @store, products: @products }
  end

  private

    def set_store
      @store = Store.find(params[:id])
    end

end
