class AddBookToReview < ActiveRecord::Migration[7.1]
  def change
    add_reference :reviews, :book, null: false, foreign_key: true
  end
end
