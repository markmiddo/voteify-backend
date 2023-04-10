class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.string :subtitle
      t.datetime :start_date
      t.datetime :end_date
      t.string :place
      t.text :description
      t.string :ticket_url
      t.text :fb_pixel
      t.text :google_analytic
      t.integer :min_user_count_to_vote
      t.string :color
      t.string :landing_image
      t.string :sharing_image
      t.string :csv_file
      t.belongs_to :client, index: true

      t.timestamps
    end
  end
end
