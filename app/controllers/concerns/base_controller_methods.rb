module BaseControllerMethods
  extend ActiveSupport::Concern

  private

  def render_resource_or_errors(resource, options = {})
    resource.try(:errors).try(:present?) ? render_errors(resource) : render_resource(resource, options)
  end

  def render_resource(resource, options = {})
    render json: resource, root: 'resource', **options
  end

  def render_errors(resource)
    render json: { errors: resource.errors }, status: :unprocessable_entity
  end

  def render_resources(resources, options = {})
    options[:meta] ||= {}
    options[:meta][:all] = resources.size
    options[:meta][:limit] = params[:limit].to_i if params[:limit].present?
    options[:meta][:offset] = params[:offset].to_i if params[:offset].present?

    render json: resources.pagination(params), root: 'resources', **options
  end
end
