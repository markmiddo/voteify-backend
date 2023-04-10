class AddIsTopToEventTrackVotes < ActiveRecord::Migration[5.1]
  def change
    add_column :event_track_votes, :is_top, :boolean, default: false, null: false
  end
end
