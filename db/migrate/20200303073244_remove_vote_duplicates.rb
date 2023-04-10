class RemoveVoteDuplicates < ActiveRecord::Migration[5.2]
  def change
    Vote.having('count(id) > 1').group(:event_id, :patron_id).select(:event_id, :patron_id).each do |duplicate|
      Vote.not_shared.where(event_id: duplicate.event_id, patron_id: duplicate.patron_id).first.destroy
    end
  end
end
