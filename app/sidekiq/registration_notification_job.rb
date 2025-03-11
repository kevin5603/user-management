class RegistrationNotificationJob
  include Sidekiq::Job

  def perform(register_id)
    @admin_email_list = User.includes(:roles).where(roles: { name: 'admin' }).pluck(:email)
    AdminMailer.registration_notification(@admin_email_list, register_id).deliver_now
  end
end
