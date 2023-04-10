class CreateViewEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :view_events do |t|
      t.belongs_to :patron, index: true
      t.belongs_to :event, index: true
      t.string :visitor_uid
      t.integer :page

      t.timestamps
    end

    add_index :view_events, [:patron_id, :event_id, :visitor_uid, :page], unique: true, name: :view_events_index
  end
end
