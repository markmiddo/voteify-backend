class ClientPolicy < UserPolicy

  def permitted_attributes
    %i[name avatar email company_name fb_url instagram_url]
  end

end

