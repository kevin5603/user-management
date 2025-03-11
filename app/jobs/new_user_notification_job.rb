class NewUserNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    new_user = User.find(user_id)

    # Find all admins (assuming you have a Role model with 'admin' role)
    admin_role = Role.find_by(name: 'admin')
    admins = admin_role.users

    # Send notification to each admin
    admins.each do |admin|
      AdminNotificationMailer.new_user_notification(admin, new_user).deliver_now
    end
  end
end