class AdminNotificationMailer < ApplicationMailer
  def new_user_notification(admins_emails, new_user)
    @user = new_user
    mail(
      to: admins_emails,
      subject: "New User Registration: #{@user.email}"
    )
  end
end
