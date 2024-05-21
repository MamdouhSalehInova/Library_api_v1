class AddBodyToReview < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :body, :text
  end
end
