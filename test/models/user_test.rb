require "test_helper"

class UserTest < ActiveSupport::TestCase

  def setup
    FactoryBot.create(:role, :admin_role)
    FactoryBot.create(:role, :manager_role)
    FactoryBot.create(:role, :regular_role)

    @admin_user = FactoryBot.create(:user, :admin_user)
    @manager_user = FactoryBot.create(:user, :manager_user)
    @regular_user = FactoryBot.create(:user, :regular_user)

    ActionMailer::Base.default_url_options[:host] = 'localhost:3000'
  end

  test "should be able to create a valid user" do
    user = User.new(
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123",
      phone_number: "1234567890"
    )
    assert user.valid?
  end

  test "should require email" do
    user = User.new(
      password: "password123",
      password_confirmation: "password123",
      phone_number: "1234567890"
    )
    assert_not user.valid?
    assert_includes user.errors.full_messages, "Email can't be blank"
  end

  test "should require password" do
    user = User.new(
      email: "test@example.com",
      phone_number: "1234567890"
    )
    assert_not user.valid?
    assert_includes user.errors.full_messages, "Password can't be blank"
  end

  test "should validate phone number format" do
    @regular_user.phone_number = "1234567890"
    assert @regular_user.valid?, "Valid phone number rejected: #{@regular_user.errors.full_messages}"

    @regular_user.phone_number = "123456789" # Too short
    assert_not @regular_user.valid?

    @regular_user.phone_number = "12345678901" # Too long
    assert_not @regular_user.valid?

    @regular_user.phone_number = "123-456-7890" # Contains non-digits
    assert_not @regular_user.valid?

    @regular_user.phone_number = "abcdefghij" # Non-numeric
    assert_not @regular_user.valid?
  end

  test "should assign Regular role.rb on save if no roles" do
    new_user = User.new(
      email: "newuser@example.com",
      password: "password123",
      password_confirmation: "password123",
      phone_number: "9876543210"
    )

    assert new_user.roles.empty?
    new_user.save
    assert_not new_user.roles.empty?
    assert new_user.roles.exists?(name: 'Regular')
  end

  test "should not assign Regular role.rb if user already has roles" do
    assert_not @admin_user.roles.empty?
    initial_roles_count = @admin_user.roles.count

    @admin_user.save
    assert_equal initial_roles_count, @admin_user.roles.count, "Additional role.rb was added despite user already having roles"
  end

  test "admin? returns true for admin users" do
    assert @admin_user.admin?
    assert_not @regular_user.admin?
  end

  test "manager? returns true for manager users" do
    assert @manager_user.manager?
    assert_not @regular_user.manager?
  end

  test "regular? returns true for regular users" do
    assert @regular_user.regular?
    assert_not @admin_user.regular?, "Manager user incorrectly identified as regular user"
  end

end
