  class AddIndexForUniquenessEventPatronForVote < ActiveRecord::Migration[5.2]
  def change
    add_index :votes, [:event_id, :patron_id]
  end
end
