class ChangeOrderBookIdToNotNull < ActiveRecord::Migration[7.1]
  def up
    change_column :orders, :book_id, :bigint, null: false
  end
  def down 
    change_column :orders, :book_id, :bigint, null: true
  end
end
