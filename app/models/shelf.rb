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
  

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "current_capacity", "id", "id_value", "max_capacity", "name", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["books"]
  end
  
end
