class ChangePriorityColumnToOrderInTasks < ActiveRecord::Migration[7.0]
  def change
    remove_column :tasks, :priority
    add_column :tasks, :order, :serial
  end
end
