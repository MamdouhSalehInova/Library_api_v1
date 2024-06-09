class Review < ApplicationRecord

  #callbacks
  after_create :update_book_rating
  after_destroy :update_book_rating


  #associations
  belongs_to :user
  belongs_to :book

  #validations
  validates :body, presence: true
  validates :rating, presence: true
  
  def update_book_rating
    average_rating = book.reviews.average(:rating).to_f
    book.update(ratings: average_rating)
   
  end
  
end
