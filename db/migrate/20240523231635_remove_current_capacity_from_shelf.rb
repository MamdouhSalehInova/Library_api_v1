class RemoveCurrentCapacityFromShelf < ActiveRecord::Migration[7.1]
  def change
    remove_column :shelves, :current_capacity, :integer
  end
end
