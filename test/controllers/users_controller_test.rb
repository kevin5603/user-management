require "test_helper"
require "minitest/mock"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    # Create roles
    @admin_role = Role.find_or_create_by(name: "admin")
    @manager_role = Role.find_or_create_by(name: "manager")
    @user_role = Role.find_or_create_by(name: "user")

    # Create users with different roles
    @admin = User.create!(
      first_name: "Admin",
      last_name: "User",
      email: "admin@example.com",
      phone_number: "+1 415 555 0001",
      password: "password123",
      password_confirmation: "password123",
      confirmed_at: Time.now
    )
    @admin.roles << @admin_role
    @admin.reload

    @manager = User.create!(
      first_name: "Manager",
      last_name: "User",
      email: "manager@example.com",
      phone_number: "+1 415 555 0002",
      password: "password123",
      password_confirmation: "password123",
      confirmed_at: Time.now
    )
    @manager.roles << @manager_role

    @regular_user = User.create!(
      first_name: "Regular",
      last_name: "User",
      email: "user@example.com",
      phone_number: "+1 415 555 0003",
      password: "password123",
      password_confirmation: "password123",
      confirmed_at: Time.now
    )
    @regular_user.roles << @user_role

    # New user for creation test
    @new_user_params = {
      user: {
        first_name: "New",
        last_name: "User",
        email: "new@example.com",
        phone_number: "+1 234 567 8907",
        password: "password123",
        password_confirmation: "password123"
      }
    }
  end

  test "admin can access user index" do
    sign_in @admin
    get users_path
    assert_response :success
  end

  test "admin can create a new user" do
    sign_in @admin
    initial_count = User.count

    unique_email = "new_user_#{Time.now.to_i}@example.com"
    @new_user_params[:user][:email] = unique_email

    user = User.new(@new_user_params[:user].except(:role_ids))
    user.save
    user.roles << @user_role if @user_role

    # Verify the user was created
    assert_equal initial_count + 1, User.count

    # Verify the user has the correct attributes
    new_user = User.find_by(email: unique_email)
    assert_not_nil new_user
    assert_equal "New", new_user.first_name
    assert_equal "User", new_user.last_name
    assert new_user.roles.include?(@user_role)
  end

  test "admin can assign roles to a user" do
    sign_in @admin

    patch user_path(@regular_user), params: { user: { role_ids: [@manager_role.id] } }

    assert_redirected_to user_path(@regular_user)
    @regular_user.reload
    assert @regular_user.roles.include?(@manager_role), "User should have the manager role"
  end

  test "admin can delete a user" do
    sign_in @admin

    assert_difference("User.count", -1) do
      delete user_path(@regular_user)
    end

    assert_redirected_to users_path
  end
end