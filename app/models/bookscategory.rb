class BooksCategory < ApplicationRecord
  belongs_to :category
  belongs_to :book
  end
