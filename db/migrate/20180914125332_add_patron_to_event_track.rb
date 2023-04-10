class AddPatronToEventTrack < ActiveRecord::Migration[5.1]
  def change
    add_column :event_tracks, :patron_id, :integer, limit: 8
    add_index  :event_tracks, :patron_id
  end
end
