class RemoveAdminFromUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :admin, :boolean
  end
end
