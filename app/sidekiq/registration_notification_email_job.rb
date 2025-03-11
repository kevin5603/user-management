class RegistrationNotificationEmailJob
  include Sidekiq::Job
  sidekiq_options retry: 3

  def perform(user_id)
    AdminMailer.with(user_id: user_id).new_registration_notification_email.deliver_now
  end
end
