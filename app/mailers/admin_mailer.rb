class AdminMailer < ApplicationMailer

  default from: "no-reply@tao.user.management.com"

  def registration_notification(admin_email_list, register_id)
    @user = User.find(register_id)
    mail to: admin_email_list, subject: "Registration Notification"
  end
end
