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
    update(status: 1)
    book.set_not_available
    Shelf.decrement_counter(:current_capacity, book.shelf.id, by: 1)
    UserMailer.accepted(user, book).deliver_later
  end
  
  def reject
    update(status: 2)
    UserMailer.rejected(user, book).deliver_later
  end
  
  def return
    update(status: 3)
    book.set_is_available
    Shelf.increment_counter(:current_capacity, book.shelf.id, by: 1)
    UserMailer.returned(user, book).deliver_later
  end
  
end
