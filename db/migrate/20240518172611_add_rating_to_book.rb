class AddRatingToBook < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :rating, :float
  end
end
