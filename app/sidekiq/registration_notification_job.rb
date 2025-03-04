class RegistrationNotificationJob
  include Sidekiq::Job

  def perform(register_email, first_name, last_name)
    # Do something
    puts "===== start job ====="
    @users = User.includes(:roles).where(roles: { name: 'admin' })
    @users.each do |admin|
      puts "=== admin: #{admin.email} ==="
      AdminMailer.registration_notification(admin.email, register_email, first_name, last_name).deliver_now
    end
    puts "===== finish job ====="
  end
end
