class ChangePriorityColumnToOrderInTasks < ActiveRecord::Migration[7.0]
  def change
    remove_column :tasks, :priority, :integer
    add_column :tasks, :position, :serial
  end
end
