class AddOrderColumnToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :order, :serial
  end
end
