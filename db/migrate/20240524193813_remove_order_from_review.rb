class RemoveOrderFromReview < ActiveRecord::Migration[7.1]
  def change
    remove_column :reviews, :order_id, :integer
  end
end
