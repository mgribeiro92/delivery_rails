# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def reset_password
    UserMailer.reset_password(User.find(29))
  end

end
