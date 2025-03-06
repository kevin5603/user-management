require 'test_helper'
require 'sidekiq/testing'
require "minitest/mock"

class RegistrationNotificationJobTest < ActiveJob::TestCase
  def setup
    @expected_admin_emails = [users(:admin_user).email, users(:admin_user2).email]
    @new_user = users(:regular_user)
  end

  test "retrieves correct admin emails before sending notification" do
    job = RegistrationNotificationJob.new
    job.perform(@new_user.email, @new_user.first_name, @new_user.last_name)

    assert_equal @expected_admin_emails, job.instance_variable_get(:@admin_email_list)
  end

  test "sends email when job executes" do
    mock_mailer = Minitest::Mock.new
    mock_mailer.expect(:deliver_now, true)

    AdminMailer.stub :registration_notification, mock_mailer do
      RegistrationNotificationJob.new.perform(@new_user.email, @new_user.first_name, @new_user.last_name)
    end

    mock_mailer.verify
  end

end