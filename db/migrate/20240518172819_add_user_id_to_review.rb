class AddUserIdToReview < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :user_id, :bigint
  end
end
