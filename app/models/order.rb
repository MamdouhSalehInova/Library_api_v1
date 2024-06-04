class Order < ApplicationRecord

  #callbacks
  after_create :notify_admin

  #associations
  belongs_to :user
  belongs_to :book

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


  def accept
    self.update(status: 1)
    self.book.set_not_available
    UserMailer.accepted(self.user, self.book).deliver_later
  end
  
  def reject
    self.update(status: 2)
    UserMailer.rejected(self.user, self.book).deliver_later
  end
  
  def return
    self.update(status: 3)
    self.book.set_is_available
    UserMailer.returned(self.user, self.book).deliver_later
  end
  
end
