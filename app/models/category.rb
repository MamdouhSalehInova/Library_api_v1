class Category < ApplicationRecord

  #associations
  has_many :books_categories, dependent: :destroy
  has_many :books, through: :books_categories
  
  #validations
  validates :name, presence: true, uniqueness: true

  
end
