class Api::StoresController < ApplicationController
  before_action :set_store, only: %i[ show ]
  before_action :check_token!, only: [ :user_store ]
  rescue_from User::InvalidToken, with: :not_authorized

  def index
    stores =  Store.all
    render json: stores
  end

  def show
    @products = @store.products
    render json: { store: @store, products: @products }
  end

  def user_store
    user = @user
    render json: user.stores
  end

  private

    def set_store
      @store = Store.find(params[:id])
    end

    def not_authorized(e)
      render json: {message: "Nope!"}, status: 401
    end

end
