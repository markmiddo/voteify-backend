class TermsAndConditionsController < ApiController
  before_action :skip_authorization

  expose :terms_and_condition, -> { TermsAndCondition.first }

  # before_action :authenticate_user

  def index
    render_resource_or_errors terms_and_condition
  end
end
