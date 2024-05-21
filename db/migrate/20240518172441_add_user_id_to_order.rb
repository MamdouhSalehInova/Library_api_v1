class AddUserIdToOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :user_id, :bigint
  end
end
