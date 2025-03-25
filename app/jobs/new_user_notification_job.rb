class NewUserNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    begin
      new_user = User.find_by!(id: user_id)
      Rails.logger.info "Job: Found user #{new_user.inspect}"
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error "Could not find user with ID: #{user_id}"
      return
    end

    begin
      admins_emails = User.admin_users.pluck(:email)

      if admins_emails.empty?
        Rails.logger.warn "No admin users found to receive new user notification"
        return
      end

      AdminNotificationMailer.new_user_notification(admins_emails, new_user).deliver_now

    rescue StandardError => e
      Rails.logger.error "Failed to send new user notification: #{e.message}"
    end
  end
end
