class AddSharingImageToShow < ActiveRecord::Migration[5.1]
  def change
    add_column :votes, :sharing_image, :string
  end
end
