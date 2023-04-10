class VotePolicy < ApplicationPolicy

  def update?
    record.not_shared? && record.patron.id == user.id
  end

  def permitted_attributes
    [:status, :event_id, event_track_votes_attributes: %i[id position event_track_id _destroy is_top] ]
  end
end

