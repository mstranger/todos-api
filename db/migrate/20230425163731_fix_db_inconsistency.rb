class FixDbInconsistency < ActiveRecord::Migration[7.0]
  def change
    change_column_null :projects, :name, false
    change_column_null :tasks, :completed, false
  end
end
