class AddColumnToEventTrack < ActiveRecord::Migration[5.2]
  def change
    add_column :event_tracks, :vote_points_offset, :integer, default: 0
  end
end
