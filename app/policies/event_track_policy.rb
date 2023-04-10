class EventTrackPolicy < ApplicationPolicy

  def create?
    user.try(:present?) ? user.patron? : true
  end

  def destroy?
    user.client? && user.events.where(id: record.event_id).exists?
  end

  def permitted_attributes
    %i(event_id author title)
  end
end
