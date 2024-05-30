class Review < ApplicationRecord

  #associations
  belongs_to :user
  belongs_to :book

  #validations
  validates :body, presence: true
  validates :rating, presence: true
  
end
