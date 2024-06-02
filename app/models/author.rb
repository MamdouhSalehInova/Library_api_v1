class Author < ApplicationRecord

  #associations
  has_many :books

  #validations
  validates :name, presence: true, uniqueness: true

end
