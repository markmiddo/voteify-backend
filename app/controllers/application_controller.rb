class ApplicationController < ActionController::Base

  include BaseControllerMethods

  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery unless: -> { request.format.json? }

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name email password password_confirmation type company_name])
  end
end

