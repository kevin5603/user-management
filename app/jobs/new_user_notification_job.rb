class NewUserNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    new_user = User.find_by(id: user_id)
    return unless new_user

    admins = User.admin_users.pluck(:email)
    return if admins.empty?

    # Send notification to all admins
    AdminNotificationMailer.new_user_notification(admins, new_user).deliver_now
  end
end