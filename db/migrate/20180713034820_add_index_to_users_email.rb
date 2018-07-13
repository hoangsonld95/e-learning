class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  # Make sure uniqueness at DB level
  def change
    add_index :users, :email, unique: true
  end
end
