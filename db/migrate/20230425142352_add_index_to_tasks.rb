class AddIndexToTasks < ActiveRecord::Migration[7.0]
  def change
    remove_index :tasks, :title, if_exists: true
    add_index :tasks, [:title, :project_id], unique: true
  end
end
