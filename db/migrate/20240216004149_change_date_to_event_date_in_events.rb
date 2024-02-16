class ChangeDateToEventDateInEvents < ActiveRecord::Migration[7.1]
  def up
    # Add a new column with the desired type
    add_column :events, :new_event_date, :date

    # Update the new column with data from the old column
    execute('UPDATE events SET new_event_date = date::date')

    # Remove the old column
    remove_column :events, :date

    # Rename the new column to match the desired name
    rename_column :events, :new_event_date, :event_date
  end

  def down
    # Reverse the migration if needed
    rename_column :events, :event_date, :new_event_date
    add_column :events, :date, :string
    execute('UPDATE events SET date = new_event_date')
    remove_column :events, :new_event_date
  end
end
