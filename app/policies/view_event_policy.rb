class ViewEventPolicy < ApplicationPolicy

  def create?
    true
  end

  def permitted_attributes
    %i(event_id patron_id visitor_uid page)
  end
end
