class MakeEventVoteEndDateNotNullable < ActiveRecord::Migration[5.2]
  def change
    change_column :events, :vote_end_date, :datetime, null: false
  end
end
