require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    User.destroy_all
    Role.find_or_create_by(name: "user")

    @user = User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "john_#{SecureRandom.hex(4)}@example.com",
      phone_number: "+1 415 555 1234",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "valid user" do
    assert @user.valid?
  end

  test "first name is required" do
    @user.first_name = ""
    assert_not @user.valid?
    assert_includes @user.errors[:first_name], "can't be blank"
  end

  test "last name is required" do
    @user.last_name = ""
    assert_not @user.valid?
    assert_includes @user.errors[:last_name], "can't be blank"
  end

  test "email is required" do
    @user.email = ""
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "phone number is required" do
    @user.phone_number = ""
    assert_not @user.valid?
    assert_includes @user.errors[:phone_number], "can't be blank"
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "full name method returns combined name" do
    assert_equal "John Doe", @user.full_name
  end

  test "default role assignment" do
    @user.save
    assert_includes @user.roles.pluck(:name), "user"
  end
end
