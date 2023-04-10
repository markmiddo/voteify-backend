class RenameEventColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :min_user_count_to_vote, :track_count_for_vote
  end
end
