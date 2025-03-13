require 'test_helper'
require 'sidekiq/testing'

class AdminNotificationJobTest < ActiveSupport::TestCase

  setup do
    Sidekiq::Testing.fake!

    @regular_user = users(:regular_user)
    @admin_user = users(:admin_user)

  end

  test "job performs correctly with real data" do
    assert @admin_user.admin?, "Test requires an admin user"

    mock_mail_object = Minitest::Mock.new
    mock_mail_object.expect :deliver_now, true

    NewRegistrationAdminMailer.stub :new_user_notification, ->(user, admin_emails) {
      assert_equal @regular_user.id, user.id
      assert_includes admin_emails, @admin_user.email
      mock_mail_object
    } do
      AdminNotificationJob.new.perform(@regular_user.id)
    end

    assert_mock mock_mail_object
  end

  test "job can be executed through Sidekiq testing" do
    Sidekiq::Testing.inline! do

      mock_mail = Minitest::Mock.new
      mock_mail.expect :deliver_now, true

      NewRegistrationAdminMailer.stub :new_user_notification, mock_mail do
        AdminNotificationJob.perform_async(@regular_user.id)
      end

      assert_mock mock_mail
    end
  ensure
    Sidekiq::Testing.fake!
  end

  test "job is pushed to queue" do
    assert_equal 0, AdminNotificationJob.jobs.size
    AdminNotificationJob.perform_async(@regular_user.id)
    assert_equal 1, AdminNotificationJob.jobs.size
  end

  test "job sends notification email to admin" do
    mock_mailer = Minitest::Mock.new
    mock_mailer.expect :deliver_now, true

    NewRegistrationAdminMailer.stub :new_user_notification, mock_mailer do
      AdminNotificationJob.new.perform(@regular_user.id)
    end

    assert_mock mock_mailer
  end

  test "job queries for admin emails" do
    admin_emails = ['admin@example.com']
    admin_query_mock = Minitest::Mock.new
    admin_query_mock.expect :pluck, admin_emails, [:email]

    where_mock = Minitest::Mock.new
    where_mock.expect :where, admin_query_mock,[], roles: {name: 'Admin'}

    User.stub :joins, where_mock do
      mailer_mock = Minitest::Mock.new
      mailer_mock.expect :deliver_now, true

      NewRegistrationAdminMailer.stub :new_user_notification, mailer_mock do
        AdminNotificationJob.new.perform(@regular_user.id)
      end
      assert_mock mailer_mock
    end
    assert_mock where_mock
    assert_mock admin_query_mock
  end

  test "job does nothing with invalid user_id" do
    non_existent_id = -1
    assert_nil User.find_by(id: non_existent_id)

    NewRegistrationAdminMailer.stub :new_user_notification, -> (*args) {
      flunk "Mailer should not be called for invalid user_id"
    } do
      assert_nothing_raised do
        AdminNotificationJob.new.perform(non_existent_id)
      end
    end
  end
end
