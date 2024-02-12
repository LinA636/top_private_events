class AddForeignKeyToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :name, :string
    add_column :events, :description, :text
    add_reference :events, :user, null: false, foreign_key: true
  end
end
