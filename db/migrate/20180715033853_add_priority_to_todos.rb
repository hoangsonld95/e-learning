class AddPriorityToTodos < ActiveRecord::Migration[5.1]
  def change
    add_column :todos, :priority, :string
  end
end
