class Order < ApplicationRecord

  #callbacks
  after_create_commit :notify_admin

  #associations
  belongs_to :user
  belongs_to :book

  #validations
  validates :user, presence: true
  validates :book_id, presence: true
  validates :return_date, presence: true

  enum status: { pending: 0, accepted: 1, rejected: 2, returned: 3, late: 4 }

  #Send an email to all admins when a new order is created
  def notify_admin
    @admins = User.where(is_admin: true)
    AdminNotificationJob.perform_later
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
