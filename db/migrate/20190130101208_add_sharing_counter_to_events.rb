class AddSharingCounterToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :sharing_count, :integer, default: 0
  end
end
