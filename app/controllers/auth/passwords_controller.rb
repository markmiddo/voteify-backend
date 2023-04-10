class Auth::PasswordsController < DeviseTokenAuth::PasswordsController
  include Auth::Resource

  def render_create_success
    render_resource(@resource)
  end
end
