class RegistrationNotificationJob
  include Sidekiq::Job

  def perform(register_email, first_name, last_name)
    @admin_email_list = User.includes(:roles).where(roles: { name: 'admin' }).map(&:email)
    AdminMailer.registration_notification(@admin_email_list, register_email, first_name, last_name).deliver_now
  end
end
