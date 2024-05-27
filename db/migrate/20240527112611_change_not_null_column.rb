class ChangeNotNullColumn < ActiveRecord::Migration[7.1]
  def up
    change_column :books, :author_id, :bigint, null: false
    #Ex:- change_column("admin_users", "email", :string, :limit =>25)
  end
  def down 
    change_column :books, :author_id, :bigint, null: true
  end
end
