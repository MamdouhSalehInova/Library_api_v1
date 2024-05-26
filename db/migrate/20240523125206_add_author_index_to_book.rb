class AddAuthorIndexToBook < ActiveRecord::Migration[7.1]
  def change
    add_index :books, :author_id
  end
end
