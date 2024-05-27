class Book < ApplicationRecord

  after_save :update_shelf


  has_many :books_categories, dependent: :destroy
  has_many :categories, through: :books_categories


  #has_and_belongs_to_many :categories, 
  has_many :reviews, dependent: :delete_all
  belongs_to :author
  belongs_to :shelf
  validates :title, presence: true, uniqueness: true
  validates :category_ids, presence: true


  def update_shelf
    @shelf =  self.shelf
    @shelf.update(current_capacity: @shelf.books.count)
  end


  end
