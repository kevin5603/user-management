require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test "invite" do
    # Given
    sender = "no-reply@tao.user.management.com"
    admin_email_list = %w[david_admin@a.com zoe_admin@a.com]
    register_email = "new_user@a.com"
    first_name = "Kevin"
    last_name = "Lee"
    subject = "Registration Notification"
    email = AdminMailer.registration_notification(admin_email_list, register_email, first_name, last_name)

    # When
    assert_emails 1 do
      email.deliver_now
    end

    # Then
    assert_equal [sender], email.from
    assert_equal admin_email_list, email.to
    assert_equal subject, email.subject
    assert_match /A new user has signed up: new_user@a.com/, email.body.to_s
    assert_match /first name: Kevin/, email.body.to_s
    assert_match /last name: Lee/, email.body.to_s
  end
end
