class User < ApplicationRecord

  devise :database_authenticatable, :registerable, :validatable,
  :recoverable, :rememberable, :confirmable
  #:jwt_authenticatable, jwt_revocation_strategy: self
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  #associations
  has_many :orders


  def generate_jwt
    JWT.encode({id: id, exp: 60.days.from_now.to_i}, Rails.application.credentials.secret_key_base)
  end

  def revoke_jwt(token)
    Session.find_by(token: token)&.destroy
  end

  def jwt_revoked?(token)
    Session.exists?(jwt: token)
  end

  private

  #Sends a greeting email when a user confirms their email adress
  def after_confirmation
    WelcomeMailer.send_greeting_notification(self).deliver_later
  end
  
end
