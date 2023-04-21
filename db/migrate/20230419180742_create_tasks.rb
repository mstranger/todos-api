class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, index: { unique: true }
      t.datetime :deadline
      t.integer :priority, null: false, default: 0
      t.boolean :completed, default: false

      t.timestamps
    end

    add_reference :tasks, :project, null: false, foreign_key: true
  end
end
