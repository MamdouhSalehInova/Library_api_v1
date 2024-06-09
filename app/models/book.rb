class Book < ApplicationRecord
  # Callbacks
  after_update :update_old_and_new_shelf_capacity
  after_destroy :update_shelf_capacity
  after_create :update_shelf_capacity

  # Associations
  has_many :books_categories, dependent: :destroy
  has_many :categories, through: :books_categories
  has_many :reviews, dependent: :delete_all
  belongs_to :author
  belongs_to :shelf

  # Validations
  validates :title, presence: true, uniqueness: true
  validates :category_ids, presence: true, length: { maximum: 3 }

  # Updates shelf capacities when book's shelf is updated
  def update_old_and_new_shelf_capacity
    if saved_change_to_shelf_id?
      old_shelf_id, new_shelf_id = saved_change_to_shelf_id
      Shelf.decrement_counter(:current_capacity, old_shelf_id)
      Shelf.increment_counter(:current_capacity, new_shelf_id)
    end
  end

  # Updates shelf capacity when a book is created or destroyed
  def update_shelf_capacity
    Shelf.increment_counter(:current_capacity, shelf.id) if created_at == updated_at
    Shelf.decrement_counter(:current_capacity, shelf.id) if destroyed?
  end

  # Set availability
  def set_is_available
    update(is_available: true)
  end

  def set_not_available
    update(is_available: false)
  end
end