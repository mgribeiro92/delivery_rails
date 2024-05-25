class RegistrationsController < ApplicationController
  skip_forgery_protection only: [ :create, :me, :sign_in, :new_token, :update ]
  before_action :authenticate!, only: [ :me ]
  rescue_from User::InvalidToken, with: :not_authorized

  def me
    render json: {email: current_user.email, id: current_user.id}
  end

  def sign_in
    access = current_credential.access
    user = User.where(role: access).find_by(email: sign_in_params[:email])

    if !user || !user.valid_password?(sign_in_params[:password])
      render json: {message: "Email or password incorrect!"}, status: 401
    else
      token = User.token_for(user)
      if user.refresh_token.present?
        refresh_token = user.refresh_token
        if valid_refresh_token!(refresh_token)
          refresh_token = refresh_token.token
          puts 'refresh_token valido'
        else
          refresh_token = User.refresh_token_for(user)
          puts 'refresh_token invalido, foi criado outro'
        end
      else
        refresh_token = User.refresh_token_for(user)
        puts 'usuario ainda nao tem refresh_token'
      end
      render json: {email: user.email, token: token, refresh_token: refresh_token}
    end
  end

  def new_token
    refresh_token = RefreshToken.find_by(token: params[:refresh_token])
    if refresh_token && valid_refresh_token!(refresh_token)
      user = User.find_by(refresh_token: refresh_token)
      token = User.token_for(user)
      render json: {token: token}
    else
      render json: {message: "Refresh_token invalid"}, status: 401
    end
  end

  def create
    @user = User.new(user_params)
    @user.role = current_credential.access

    if @user.save
      render json: @user, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])
    puts(@user)
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private
    def not_authorized(e)
      render json: {message: "Invalid token!"}, status: 401
    end

    def user_params
      params.required(:user).permit(:email, :password, :password_confirmation)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def sign_in_params
      params.required(:login).permit(:email, :password)
    end
end
