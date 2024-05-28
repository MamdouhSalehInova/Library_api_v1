class ChangeOrderUserIdToNotNull < ActiveRecord::Migration[7.1]
  def up
    change_column :orders, :user_id, :bigint, null: false
  end
  def down 
    change_column :orders, :user_id, :bigint, null: true
  end
end
