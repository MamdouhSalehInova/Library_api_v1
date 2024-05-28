class Order < ApplicationRecord

  after_create :notify_admin

  belongs_to :user
  has_one :book
  validates :user, presence: true
  validates :book_id, presence: true
  validates :return_date, presence: true

  enum :status, [ :pending, :accepted, :rejected, :returned, :late ]

  def notify_admin
    @admins = User.where(is_admin: true)
    @admins.each do |admin|
      AdminMailer.new_order(admin).deliver_later
      end
  end
  
end
