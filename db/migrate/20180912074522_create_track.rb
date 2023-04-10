class CreateTrack < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :title,     index: true
      t.string :author,   index: true
      t.string :video_id, index: true
      t.string :thumbnails
      t.string :youtube_title
      t.text   :youtube_description

      t.datetime :published_at
    end
  end
end
