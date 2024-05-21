class Category < ApplicationRecord
  #has_many :books_categories, dependent: :delete_all
  #has_many :books, through: :books_categories, dependent: :delete_all
  has_and_belongs_to_many :books

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "name", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["books"]
  end
end
