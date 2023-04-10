class AboutUsDetailsController < ApiController
  before_action :skip_authorization

  expose :about_us_details, -> { AboutUsDetail.all }

  # before_action :authenticate_user

  def index
    render_resources(about_us_details)
  end
end
