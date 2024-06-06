class AddressesController < ApplicationController
  skip_forgery_protection only: [ :create ]

  def create
    if address_params[:store_id].present?
      @store = Store.find(address_params[:store_id])
      @address = Address.new(addressable: @store)
      permitted_params = address_params.except(:store_id)
      @address.assign_attributes(permitted_params)
    elsif address_params[:user_id].present?
      @user = User.find(address_params[:user_id])
      @address = Address.new(addressable: @user)
      permitted_params = address_params.except(:user_id)
      @address.assign_attributes(permitted_params)
    end
    if @address.save
      @address.geocode
      render json: @address
    else
      render json: @address.errors
    end
  end

  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:store_id, :user_id, :street, :number, :city, :state, :zip_code, :country)
  end


end
