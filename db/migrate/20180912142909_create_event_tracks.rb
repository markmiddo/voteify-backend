class CreateEventTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :event_tracks do |t|
      t.belongs_to :event, index: true
      t.belongs_to :track, index: true

      t.timestamps
    end
  end
end
