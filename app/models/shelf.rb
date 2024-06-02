class Shelf < ApplicationRecord

  #associations
  has_many :books

  #validations
  validates :max_capacity, presence: true
  validates :name, presence: true

  def decrement_capacity
    self.update(current_capacity: self.current_capacity - 1)
  end

  def increment_capacity
    self.update(current_capacity: self.current_capacity + 1)
  end
  
end
