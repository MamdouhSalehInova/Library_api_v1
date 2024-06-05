class Shelf < ApplicationRecord
  #associations
  has_many :books

  #validations
  validates :max_capacity, presence: true
  validates :name, presence: true

 
  
end