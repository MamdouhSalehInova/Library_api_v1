class ChangeRatingsDefault < ActiveRecord::Migration[7.1]
  def change
    change_column :books, :ratings, :float, default: 0
  end
end
