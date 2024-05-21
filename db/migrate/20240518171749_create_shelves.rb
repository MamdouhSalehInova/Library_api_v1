class CreateShelves < ActiveRecord::Migration[7.1]
  def change
    create_table :shelves do |t|
      t.string :name
      t.integer :max_capacity
      t.integer :current_capacity

      t.timestamps
    end
  end
end
