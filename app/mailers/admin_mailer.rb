class AdminMailer < ApplicationMailer
  default from: 'notifications@example.com'
  default to: proc { User.joins(:roles).where(roles: { name: :admin }).pluck(:email) }

  def new_registration_notification_email
    @user = User.find params[:user_id]
    mail subject: 'Registration Notification'
  end
end
