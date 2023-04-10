class Auth::RegistrationsController < DeviseTokenAuth::RegistrationsController
  include Auth::Resource

  def render_create_success
    render_resource(@resource)
  end

  def render_create_error
    render_errors(@resource)
  end

  def render_update_success
    render_resource(@resource)
  end

  def render_update_error
    render_errors(@resource)
  end
end
