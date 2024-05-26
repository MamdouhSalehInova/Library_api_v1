class RemoveStockFromBook < ActiveRecord::Migration[7.1]
  def change
    remove_column :books, :stock, :integer
  end
end
