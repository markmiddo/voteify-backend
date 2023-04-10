class AddSquareSharingImageToVote < ActiveRecord::Migration[5.2]
  def change
    add_column :votes, :square_sharing_image, :string
  end
end
