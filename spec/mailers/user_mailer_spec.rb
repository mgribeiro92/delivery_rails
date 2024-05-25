require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe 'reset_password' do
    let(:user) {
      user = User.new(
        email: "seller@example.com.br",
        role: "seller"
        )
      }

    it 'envia um email de redefinição de senha' do
      email = UserMailer.reset_password(user).deliver_now

      expect(ActionMailer::Base.deliveries.count).to eq(1) # Verifique se um email foi enviado
      expect(email.to).to eq([user.email]) # Verifique se o email foi enviado para o usuário correto
      expect(email.subject).to eq('Defina sua senha') # Verifique o assunto do email
    end
  end
end
