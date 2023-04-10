class AddUniqueIndexForVote < ActiveRecord::Migration[5.2]
  def change
    remove_index :votes, [:event_id, :patron_id]
    add_index :votes, [:event_id, :patron_id], unique: true
  end
end
