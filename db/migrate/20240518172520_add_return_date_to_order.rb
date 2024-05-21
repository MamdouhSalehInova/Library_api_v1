class AddReturnDateToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :return_date, :datetime
  end
end
