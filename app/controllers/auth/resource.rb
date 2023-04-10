module Auth::Resource
  protected

  def resource_class(m = nil)
    return @resource.class if @resource.present?
    if m
      mapping = Devise.mappings[m]
    else
      mapping = Devise.mappings[resource_name] || Devise.mappings.values.first
    end
    mapping.to
  end
end
