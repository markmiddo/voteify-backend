class UsersController < ApiController

  before_action :authenticate_user

  expose :user

  def show
    authorize(user)
    render_resource_or_errors(user)
  end

  def update
    authorize(user)
    user.update(permitted_attributes(user))
    render_resource_or_errors(user)
  end

  def update_type
    check_user_type
    user = current_user.update_type(params)
    render_resource_or_errors(user)
  end

  private

  def check_user_type
    raise ActionController::UnpermittedParameters.new([:type]) if params[:resource][:type] == 'Admin'
  end
end

