class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :orders

  devise :database_authenticatable, :registerable, :validatable,
  :recoverable, :rememberable, :confirmable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable


  private

  def after_confirmation
   WelcomeMailer.send_greeting_notification(self).deliver_now
  end
end
