class ChangeOrderReturnDateToNotNull < ActiveRecord::Migration[7.1]
  def up
    change_column :orders, :return_date, :datetime, null: false
  end
  def down 
    change_column :orders, :book_id, :datetime, null: true
  end
end
