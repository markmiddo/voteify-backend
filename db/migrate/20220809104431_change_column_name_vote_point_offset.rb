class ChangeColumnNameVotePointOffset < ActiveRecord::Migration[5.2]
  def change
    rename_column :event_tracks, :vote_points_offset, :duplication_points
  end
end
