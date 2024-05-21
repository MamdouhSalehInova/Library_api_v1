class Order < ApplicationRecord
  belongs_to :user
  has_one :book
  validates :user, presence: true
  validates :book_id, presence: true
  validates :return_date, presence: true

  enum :status, [ :pending, :accepted, :rejected, :returned, :late ]
end
