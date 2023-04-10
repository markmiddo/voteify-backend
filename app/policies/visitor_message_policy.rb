class VisitorMessagePolicy < ApplicationPolicy

  def permitted_attributes
    %i(email message_text)
  end
end
