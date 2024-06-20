class UsersController < ApplicationController
  include ActionController::Live
  skip_forgery_protection only: [ :update, :destroy ]
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = User.all
  end

  def edit
  end

  def show
  end

  def new
    @user = User.new
  end


  def create
    if current_user.admin?
      @user = User.new(user_params)
      @user.password = SecureRandom.hex(8)

      if @user.save!
        # UserMailer.reset_password(@user).deliver_now
        redirect_to @user, notice: 'Usuário criado com sucesso. Um e-mail para definir a senha foi enviado.'
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "Usuario atualizado com sucesso." }
        format.json { render show:, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @user.delete_soft
        puts(@user.email)
        format.html { redirect_to user_url(@user), notice: "Usuario #{@user.email} foi mudado seu status para #{@user.status}!" }
        format.json { render json: { message: "Usuario desativado!"} }
      else
        format.html { redirect_to user_url(@user), alert: 'Failed to soft delete user.'}
        format.json { render json: @user.erros, status: :unprocessable_entity}
      end
    end
    if current_user.seller?
      @user.stores.update_all(soft_delete: true)
      @user.stores.each do |store|
        store.products.update_all(soft_delete: true)
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.required(:user).permit(:email, :password, :role)
  end


end
