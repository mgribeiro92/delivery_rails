class User < ApplicationRecord
  class InvalidToken < StandardError; end

  enum :role, [:admin, :seller, :buyer]
  has_many :stores
  has_one :refresh_token
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :role, presence: true

  def self.token_for(user)
    jwt_key = Rails.application.credentials.jwt_key
    jwt_headers = {exp: 5.hour.from_now.to_i }
    payload = {id: user.id, email: user.email, role: user.role}
    JWT.encode payload.merge(jwt_headers), jwt_key, "HS256"
  end

  def self.from_token(t)
    jwt_key = Rails.application.credentials.jwt_key
    decoded = JWT.decode t, jwt_key, true, { algorithm: 'HS256' }
    user_data = decoded[0].with_indifferent_access
    User.find(user_data[:id])
  rescue JWT::ExpiredSignature
    raise InvalidToken.new
  end

  def self.refresh_token_for(user)
    token = SecureRandom.uuid
    refresh_token = RefreshToken.new(
      token: token,
      user: user,
      expires_at: 1.day.from_now.to_i
    )
    refresh_token.save
    refresh_token.token
  end

end
