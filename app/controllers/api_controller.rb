class ApiController < ActionController::API
  include BaseControllerMethods
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::Helpers
  include ActionController::Serialization
  include Pundit
  private

  def authenticate_user
    render(status: :unauthorized) if current_user.nil?
  end

  def authorize_patron
    authorize User,:is_patron?
  end

  def permitted_attributes(record, for_action = nil)
    method_name = 'permitted_attributes'
    method_name = "permitted_attributes_for_#{for_action}" if for_action.present?
    params.require(:resource).permit(policy(record).send(method_name)).to_hash.deep_symbolize_keys
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { errors: exception.message }, status: :not_found
  end

  rescue_from BadRequestError do |exception|
    render json: { errors: exception.message }, status: 400
  end

  rescue_from ActionController::ParameterMissing do |exception|
    render json: { errors: exception.message }, status: :bad_request
  end

  rescue_from ActionController::UnpermittedParameters do |exception|
    render json: { errors: exception.message }, status: :bad_request
  end

  rescue_from Pundit::NotAuthorizedError do |exception|
    policy_name = exception.policy.class.to_s.underscore

    response_msg = I18n.t("#{policy_name}.#{exception.query}", scope: :pundit, default: :default)

    render json: { errors: response_msg }, status: :forbidden
  end


end
