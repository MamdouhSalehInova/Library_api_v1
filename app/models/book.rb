class Book < ApplicationRecord
  has_many :books_categories
  has_many :categories, through: :books_categories


  #has_and_belongs_to_many :categories, 
  has_many :reviews
  belongs_to :author
  belongs_to :shelf
  validates :title, presence: true, uniqueness: true
  validates :category_ids, presence: true




  end
