class AdminNotificationMailer < ApplicationMailer
  def new_user_notification(admin, new_user)
    @admin = admin
    @user = new_user
    mail(
      to: @admin.email,
      subject: "New User Registration: #{@user.email}"
    )
  end
end