class AddBookIdToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :book_id, :bigint
  end
end
