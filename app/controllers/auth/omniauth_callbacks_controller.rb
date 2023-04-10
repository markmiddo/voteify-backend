class Auth::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
  def omniauth_success
    super do |resource|
      data = { id: resource.id }.merge @auth_params.as_json
      redirect_to DeviseTokenAuth::Url.generate(auth_origin_url, data) and return
    end
  end

  def assign_provider_attrs(user, auth_hash)
    user_attributes = {
        name:              auth_hash['info']['name'],
        remote_avatar_url: auth_hash['info']['image'],
        email:             auth_hash['info']['email']
    }
    assign_user_fb_profile_url(auth_hash, user_attributes)

    user.assign_attributes(user_attributes)
  end

  private

  def assign_user_fb_profile_url(auth_hash, user_attributes)
    # urls is https://developers.facebook.com/docs/facebook-login/permissions/#reference-user_link
    # to get this url need to pass App review https://developers.facebook.com/docs/apps/review/
    if auth_hash['provider'] == 'facebook' && auth_hash['info']['urls'].present?
      user_attributes[:fb_url] = auth_hash['info']['urls']['Facebook']
    end
  end

  def auth_origin_url
    ENV['FRONTEND_OMNIAUTH_URL']
   end
end
