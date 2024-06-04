class Shelf < ApplicationRecord

  #associations
  has_many :books

  #validations
  validates :max_capacity, presence: true
  validates :name, presence: true

  #Decrements the shelf current_capacity attribute by 1
  def decrement_capacity
    self.update(current_capacity: self.current_capacity - 1)
  end

  #Increments the shelf current_capacity attribute by 1
  def increment_capacity
    self.update(current_capacity: self.current_capacity + 1)
  end
  
end