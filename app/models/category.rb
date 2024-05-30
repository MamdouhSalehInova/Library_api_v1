class Category < ApplicationRecord

  #associations
  has_many :books_categories, dependent: :destroy
  has_many :books, through: :books_categories
  
  #validations
  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["books"]
  end
end
