class ChangeIsAvailbleToNotNull < ActiveRecord::Migration[7.1]
  def up
    change_column :books, :is_available, :boolean, null: false
  end
  def down 
    change_column :books, :is_available, :boolean, null: true
  end
end
