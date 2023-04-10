# == Schema Information
#
# Table name: visitor_messages
#
#  id           :bigint(8)        not null, primary key
#  email        :string
#  message_text :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class VisitorMessage < ApplicationRecord
  include ActiveModel::Validations

  validates :email, :message_text, presence: true
  validates :email, email: true

  after_create :send_message_to_admin

  private

  def send_message_to_admin
    VisitorMessageMailer.send_contact_message_to_admin(self).deliver_now
  end

end
