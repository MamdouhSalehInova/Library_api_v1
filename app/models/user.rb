class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
  :recoverable, :rememberable, :confirmable,
  :jwt_authenticatable, jwt_revocation_strategy: self
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  #associations
  has_many :orders

  private

  #Sends a greeting email when a user confirms their email adress
  def after_confirmation
    WelcomeMailer.send_greeting_notification(self).deliver_later
  end
  
end
