class AddStockToBook < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :stock, :integer
  end
end
