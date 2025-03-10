require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test "invite" do
    sender = "no-reply@tao.user.management.com"
    admin = FactoryBot.create(:user, :admin, email: 'admin@a.com')
    admin2 = FactoryBot.create(:user, :admin, email: 'admin2@a.com')
    admin_email_list = [admin.email, admin2.email]
    register_user = FactoryBot.create(:user, :unconfirmed)
    subject = "Registration Notification"
    email = AdminMailer.registration_notification(admin_email_list, register_user.id)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [sender], email.from
    assert_equal admin_email_list, email.to
    assert_equal subject, email.subject
    assert_match /A new user has signed up: #{register_user.email}/, email.body.to_s
    assert_match /first name: #{register_user.first_name}/, email.body.to_s
    assert_match /last name: #{register_user.last_name}/, email.body.to_s
  end
end
