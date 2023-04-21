class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :projects, [:name, :user_id], unique: true
  end
end
