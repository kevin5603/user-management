# test/jobs/new_user_notification_job_test.rb
require 'test_helper'
require 'sidekiq/testing'

class NewUserNotificationJobTest < ActiveJob::TestCase
  test "enqueues a job to notify admin on new registration" do
    # Remove Sidekiq::Testing.fake! block if you're solely relying on ActiveJob::TestCase
    # Otherwise, if you want to ensure Sidekiq behavior, keep it in your test setup.
    assert_enqueued_with(job: NewUserNotificationJob) do
      User.create!(
        first_name: 'Test',
        last_name: 'User',
        email: 'test@example.com',
        job_title: 'Tester',
        phone_number: '+1 415 555 0006',
        password: 'test1234',
        password_confirmation: 'test1234'
      )
    end
  end
end
