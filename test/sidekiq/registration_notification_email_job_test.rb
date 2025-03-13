require 'test_helper'
require 'sidekiq/testing'
require 'minitest/mock'

class RegistrationNotificationEmailJobTest < ActiveJob::TestCase
  def setup
    FactoryBot.create(:user, :admin)
    @user = User.create!(email: 'email@example.com', password: 'password')
  end

  test 'sends email when perform' do
    mock_mailer = Minitest::Mock.new
    mock_mailer.expect :deliver_now, true

    AdminMailer.stub :new_registration_notification_email, mock_mailer do
      RegistrationNotificationEmailJob.new.perform(@user.id)
    end
  end
end
