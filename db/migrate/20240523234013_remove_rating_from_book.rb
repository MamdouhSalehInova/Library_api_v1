class RemoveRatingFromBook < ActiveRecord::Migration[7.1]
  def change
    remove_column :books, :rating, :float
  end
end
