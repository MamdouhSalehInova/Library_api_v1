class Book < ApplicationRecord

  after_save :update_shelf
  after_destroy :remove_book_from_shelf

  has_many :books_categories, dependent: :destroy
  has_many :categories, through: :books_categories
  has_many :reviews, dependent: :delete_all
  belongs_to :author
  belongs_to :shelf
  validates :title, presence: true, uniqueness: true
  validates :category_ids, presence: true

  def update_shelf
    @shelf =  self.shelf
    @shelf.update(current_capacity: @shelf.current_capacity + 1)
    if self.shelf_id_previously_was != nil
    @old_shelf = Shelf.find(self.shelf_id_previously_was)
    @old_shelf.update(current_capacity: @old_shelf.current_capacity - 1)
    end
  end

  def remove_book_from_shelf
    @shelf =  self.shelf
    @shelf.update(current_capacity: @shelf.current_capacity - 1)
  end
  
  end
