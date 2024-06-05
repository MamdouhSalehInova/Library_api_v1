class Book < ApplicationRecord


  #callbacks
  after_update :update_old_shelf
  after_destroy :remove_book_from_shelf
  after_create :increment_shelf_capacity

  #associations
  has_many :books_categories, dependent: :destroy
  has_many :categories, through: :books_categories
  has_many :reviews, dependent: :delete_all
  belongs_to :author
  belongs_to :shelf


  #validations
  validates :title, presence: true, uniqueness: true
  validates :category_ids, presence: true, length: { maximum: 3 }

  #Updates shelves when updating book's shelf
  def update_old_shelf
    @shelf =  self.shelf
    if self.shelf_id_before_last_save != @shelf.id
      @shelf.increment_capacity
      @old_shelf = Shelf.find(self.shelf_id_before_last_save)
      @old_shelf.decrement_capacity
    end
  end

  #Updates shelf when a book is deleted
  def remove_book_from_shelf
    Shelf.decrement_counter(:current_capacity, shelf.id, by: 1)
  end
  
  #Updates shelf when a book is created
  def increment_shelf_capacity
    Shelf.increment_counter(:current_capacity, shelf.id, by: 1)
  end

  def set_is_available
    lock!
    update(is_available: true)
  end

  def set_not_available
    lock!
    update(is_available: false)
  end

end
