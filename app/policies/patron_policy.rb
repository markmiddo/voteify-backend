class PatronPolicy < UserPolicy

  def permitted_attributes
     [:name, :avatar, :email, :fb_url, :instagram_url, answers_attributes: %i[id answer_value question_id _destroy]]
  end

end

