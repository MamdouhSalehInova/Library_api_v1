class AddAuthorIdToBook < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :author_id, :bigint
  end
end
