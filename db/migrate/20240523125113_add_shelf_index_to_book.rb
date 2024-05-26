class AddShelfIndexToBook < ActiveRecord::Migration[7.1]
  def change
    add_index :books, :shelf_id
  end
end
