class NewRegistrationAdminMailer < ApplicationMailer
  def new_user_notification(user, admin_emails)
    @user = user
    mail(
      to: admin_emails,
      subject: "New user registration: #{@user.first_name + " " + @user.last_name}"
    )
  end
end