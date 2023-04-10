class AddIndexToEventTrack < ActiveRecord::Migration[5.1]
  def change
    add_index :event_tracks, [:event_id, :track_id], unique: true
  end
end
