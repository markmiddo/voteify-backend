class AddNewPropertiesToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :facebook_title, :string, null: false
    add_column :events, :facebook_description, :string, null: false
    add_column :events, :event_url, :string
    add_column :events, :share_title, :string, null: false
    add_column :events, :share_description, :string, null: false
    add_column :events, :top_songs_description, :string, null: false
    add_column :events, :square_image, :string
    add_column :events, :text_color, :integer, null: false, default: 0
  end
end
