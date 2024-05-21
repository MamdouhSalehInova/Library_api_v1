class RemoveStatusFromOrder < ActiveRecord::Migration[7.1]
  def change
    remove_column :orders, :status, :string
  end
end
