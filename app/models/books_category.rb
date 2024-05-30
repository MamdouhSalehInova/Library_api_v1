class BooksCategory < ApplicationRecord
  
  #associations
  belongs_to :category
  belongs_to :book

end
