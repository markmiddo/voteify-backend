class AddViewEventsCounterToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :views_count, :integer, default: 0
  end
end
