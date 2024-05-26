class AddNewStockToBook < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :stock, :integer, default: 1
  end
end
