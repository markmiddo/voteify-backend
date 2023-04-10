class AddVoteEndDateToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :vote_end_date, :datetime
  end
end
