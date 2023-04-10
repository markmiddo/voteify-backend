class AddCounterCache < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :votes_count, :integer, default: 0
    add_column :event_tracks, :event_track_votes_count, :integer, default: 0
  end
end
