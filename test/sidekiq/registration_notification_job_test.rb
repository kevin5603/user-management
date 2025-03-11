require 'test_helper'
require 'sidekiq/testing'
require "minitest/mock"

class RegistrationNotificationJobTest < ActiveJob::TestCase
  def setup
    admin = FactoryBot.create(:user, :admin)
    admin2 = FactoryBot.create(:user, :admin)
    @expected_admin_emails = [admin.email, admin2.email]
    @new_user = FactoryBot.create(:user)
  end

  test "retrieves correct admin emails before sending notification" do
    job = RegistrationNotificationJob.new
    job.perform(@new_user.id)

    assert_equal @expected_admin_emails.to_set, job.instance_variable_get(:@admin_email_list).to_set

  end

  test "sends email when job executes" do
    mock_mailer = Minitest::Mock.new
    mock_mailer.expect(:deliver_now, true)

    AdminMailer.stub :registration_notification, mock_mailer do
      RegistrationNotificationJob.new.perform(@new_user.id)
    end

    mock_mailer.verify
  end

end