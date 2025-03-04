class AdminMailer < ApplicationMailer

  default from: "no-reply@tao.user.management.com"

  def registration_notification(email, first_name, last_name)
    @email = email
    @first_name = first_name
    @last_name = last_name
    mail to: @email, subject: 'Registration Notification'
  end
end
