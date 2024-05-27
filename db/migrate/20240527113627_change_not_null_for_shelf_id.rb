class ChangeNotNullForShelfId < ActiveRecord::Migration[7.1]
  def up
    change_column :books, :shelf_id, :bigint, null: false
  end
  def down 
    change_column :books, :shelf_id, :bigint, null: true
  end
end
