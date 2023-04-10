# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  allow_password_change  :boolean          default(FALSE), not null
#  avatar                 :string
#  company_name           :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  fb_url                 :string
#  instagram_url          :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  remember_token         :string
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  tokens                 :json
#  type                   :string
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email_and_provider  (email,provider) UNIQUE
#  index_users_on_type                (type)
#  index_users_on_uid_and_provider    (uid,provider) UNIQUE
#

class User < ApplicationRecord

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, omniauth_providers: %i[facebook twitter google_oauth2]
  include DeviseTokenAuth::Concerns::User

  validates :type, acceptance: { accept: %w(Client Patron) }, on: :create, allow_blank: true
  validates :email, uniqueness: { scope: :provider }

  mount_uploader :avatar, AvatarUploader

  def update_type(params)
    update(type: params[:resource][:type])
    User.find(id)
  end

  def admin?
    type == 'Admin'
  end

  def client?
    type == 'Client'
  end

  def patron?
    type == 'Patron'
  end
end
