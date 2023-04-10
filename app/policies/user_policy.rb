class UserPolicy < ApplicationPolicy
  def show?
    user.id == record.id
  end

  def update?
    user.id == record.id
  end

  def update_type?
    update?
  end

  def is_patron?
    user.patron?
  end

  def permitted_attributes
    %i[name avatar email type fb_url instagram_url]
  end
end
