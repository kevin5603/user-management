class AdminNotificationJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find(user_id)
    return unless user

    admin_email = User.joins(:roles).where(roles: {name: 'Admin'}).pluck(:email)
    NewRegistrationAdminMailer.new_user_notification(user, admin_email).deliver_now
  end
end
