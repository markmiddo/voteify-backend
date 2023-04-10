class Auth::SessionsController < DeviseTokenAuth::SessionsController
  include Auth::Resource

  def render_create_success
    render_resource(@resource)
  end
end
