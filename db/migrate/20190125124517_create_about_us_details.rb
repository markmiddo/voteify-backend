class CreateAboutUsDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :about_us_details do |t|
      t.string :subtitle
      t.string :body

      t.timestamps
    end
  end
end
