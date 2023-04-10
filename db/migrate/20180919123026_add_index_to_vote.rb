class AddIndexToVote < ActiveRecord::Migration[5.1]
  def change
    add_index :votes, :created_at
  end
end
