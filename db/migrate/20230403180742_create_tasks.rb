class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, index: { unique: true }
      t.datetime :deadline
      t.string :priority
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
