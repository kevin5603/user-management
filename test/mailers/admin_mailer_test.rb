require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test 'should retrieve correct admin email list' do
    sender = 'notifications@example.com'
    admin1 = FactoryBot.create(:user, :admin)
    admin2 = FactoryBot.create(:user, :admin)
    new_user = FactoryBot.create(:user)
    mail_list = [admin1.email, admin2.email]

    email = AdminMailer.with(user_id: new_user.id).new_registration_notification_email

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal sender, email.from.first
    assert_equal mail_list, email.to
  end
end
