class RegistrationNotificationJob
  include Sidekiq::Job

  def perform(email, first_name, last_name)
    # Do something
    puts "===== start job ====="
    AdminMailer.registration_notification(email, first_name, last_name).deliver_now
    puts "===== finish job ====="
  end
end
