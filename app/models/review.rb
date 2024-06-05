class Review < ApplicationRecord

  #associations
  belongs_to :user
  belongs_to :book

  #validations
  validates :body, presence: true
  validates :rating, presence: true
  
  after_create :update_book_rating

  def update_book_rating
    sum = 0
    # book.lock!
    # if book.ratings.present?
    # book.update(ratings: (book.ratings + rating) / 2)
    # else
    #   book.update(ratings: rating)
    # end
    book.reviews.each do |review|
      sum += review.rating
    end
    Book.where(id: book.id).update_all(ratings: sum / book.reviews.count)
  end
  
end
