class AddAvailableToBook < ActiveRecord::Migration[7.1]
  def up
    add_column :books, :is_available, :boolean, default: true
    #Ex:- :default =>''
  end
  def down
    remove_column :books, :is_available, :boolean
    #Ex:- :default =>''
  end
end
