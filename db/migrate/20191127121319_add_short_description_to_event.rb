class AddShortDescriptionToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :shortlist_description, :string
  end
end
