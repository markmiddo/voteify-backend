class VisitorMessageMailer < ApplicationMailer

  def send_contact_message_to_admin(message)
    @visitor_message = message
    mail(to: ENV['ADMIN_EMAIL'], subject: 'New message from visitor')
  end
end
