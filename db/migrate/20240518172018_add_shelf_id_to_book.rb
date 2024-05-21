class AddShelfIdToBook < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :shelf_id, :bigint
  end
end
