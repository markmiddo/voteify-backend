class Auth::TokenValidationsController < DeviseTokenAuth::TokenValidationsController
  include Auth::Resource

  def render_validate_token_success
    render_resource(@resource)
  end
end
