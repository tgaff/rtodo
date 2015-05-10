class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.string :title
      t.boolean :is_complete, default: false

      t.timestamps null: false
    end
  end
end
