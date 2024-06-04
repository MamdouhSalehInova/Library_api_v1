class Order < ApplicationRecord

  #callbacks
  after_create :notify_admin

  #associations
  belongs_to :user
  has_one :book

  #validations
  validates :user, presence: true
  validates :book_id, presence: true
  validates :return_date, presence: true

  enum :status, [ :pending, :accepted, :rejected, :returned, :late ]

  #Send an email to all admins when a new order is created
  def notify_admin
    @admins = User.where(is_admin: true)
    @admins.each do |admin|
      AdminMailer.new_order(admin).deliver_later
      end
  end
  
end
