class AddColumnsForUploadDocumentsMetadata < ActiveRecord::Migration[5.2]
  def change
    add_column :event_tracks, :original_title, :string, nullable: true
    add_column :event_tracks, :original_author, :string, nullable: true
    add_column :events, :csv_processed_line_count, :integer, default: 0
  end
end
