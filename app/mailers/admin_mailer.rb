class AdminMailer < ApplicationMailer

  default from: "no-reply@tao.user.management.com"

  def registration_notification(admin_email_list, register_email, first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @register_email = register_email
    mail to: admin_email_list, subject: "Registration Notification"
  end
end
