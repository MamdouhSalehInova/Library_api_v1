class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :body, presence: true
  validates :rating, presence: true
end
