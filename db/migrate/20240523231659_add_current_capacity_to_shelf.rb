class AddCurrentCapacityToShelf < ActiveRecord::Migration[7.1]
  def change
    add_column :shelves, :current_capacity, :integer, default: 0
  end
end
