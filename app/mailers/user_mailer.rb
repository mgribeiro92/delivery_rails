class UserMailer < ApplicationMailer
  default from: 'notificacoes@exemplo.com'

  def reset_password(user)
    @user = user
    @user.restore_reset_password_token!
    mail(to: @user.email, subject: 'Defina sua senha')
  end
end
