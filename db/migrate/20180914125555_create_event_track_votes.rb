class CreateEventTrackVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :event_track_votes do |t|
      t.belongs_to :vote, index:true
      t.belongs_to :event_track, index: true
      t.integer :position
      t.timestamps
    end
  end
end
