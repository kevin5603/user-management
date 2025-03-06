require "test_helper"
require "minitest/mock"

class UserTest < ActiveSupport::TestCase

  def setup
    @valid_user_params = {
      email: "test@a.com",
      password: "p@ssw0rd",
      first_name: "John",
      last_name: "Doe",
      phone_number: "0912345678",
    }
  end

  test "creating a user assigns default role" do
    user = User.create!(@valid_user_params)

    assert user.roles.exists?(name: "regular_user"), "User should be assigned a default role"
  end

  test "creating a user enqueues notification job" do
    mock_job = Minitest::Mock.new

    RegistrationNotificationJob.stub :perform_async, mock_job do
      User.create!(@valid_user_params)
    end

    mock_job.verify
  end

  test "valid phone number format" do
    user = User.new(@valid_user_params)

    user.phone_number = "0912345678"
    assert user.valid?, "Valid phone number should be accepted"

    user.phone_number = "0812345678"
    assert_not user.valid?, "Phone number prefix should be 09"

    user.phone_number = "091234567"
    assert_not user.valid?, "Too short phone number should be rejected"

    user.phone_number = "09123456789"
    assert_not user.valid?, "Too long phone number should be rejected"

    user.phone_number = "abcd1234567"
    assert_not user.valid?, "Non-numeric phone number should be rejected"
  end


end
