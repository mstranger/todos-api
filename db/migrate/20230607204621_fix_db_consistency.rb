class FixDbConsistency < ActiveRecord::Migration[7.0]
  def up
    remove_index :tasks, [:title, :project_id]

    remove_index :users, :email
    add_index :users, "lower(email)", unique: true

    remove_index :projects, [:name, :user_id]
    add_index :projects, "lower(name), user_id", name: "index_projects_on_lower_name_and_user_id", unique: true

    add_index :tasks, "lower(title), project_id", name: "index_tasks_on_lower_title_and_project_id", unique: true
    change_column_null :comments, :content, true

    change_column :projects, :user_id, :bigint
    change_column :comments, :user_id, :bigint
    change_column :comments, :task_id, :bigint
    change_column :tasks, :project_id, :bigint
  end

  def down
    change_column_null :comments, :content, false

    remove_index :users, "lower(email)"
    add_index :users, :email, unique: true

    remove_index :projects, name: "index_projects_on_lower_name_and_user_id"
    add_index :projects, [:name, :user_id], unique: true

    remove_index :tasks, name: "index_tasks_on_lower_title_and_project_id"
    add_index :tasks, [:title, :project_id], unique: true

    change_column :projects, :user_id, :integer
    change_column :comments, :user_id, :integer
    change_column :comments, :task_id, :integer
    change_column :tasks, :project_id, :integer
  end
end
