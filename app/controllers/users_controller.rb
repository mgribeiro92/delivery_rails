class UsersController < ApplicationController
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

  def create
    @user = User.new(user_params)
    @user.password = SecureRandom.hex(8)

    if @user.save
      # Enviar e-mail de redefinição de senha
      UserMailer.reset_password(@user).deliver_now
      redirect_to @user, notice: 'Usuário criado com sucesso. Um e-mail para definir a senha foi enviado.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.admin?
      if @user.update(soft_delete: !@user.soft_delete)
        redirect_to user_url(@user), notice: "Usuario #{@user.email} foi mudado seu status para #{@user.status}!"
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.required(:user).permit(:email, :role)
  end

end
