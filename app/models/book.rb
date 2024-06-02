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

  def update_old_shelf
    @shelf =  self.shelf
    if self.shelf_id_before_last_save != @shelf.id
      @shelf.increment_capacity
      @old_shelf = Shelf.find(self.shelf_id_before_last_save)
      @old_shelf.decrement_capacity
    end
  end

  def remove_book_from_shelf
    @shelf =  self.shelf
    @shelf.decrement_capacity
  end
  
  def increment_shelf_capacity
    @shelf = self.shelf
    @shelf.increment_capacity
  end

end
