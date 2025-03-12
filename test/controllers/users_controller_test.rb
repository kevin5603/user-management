require "test_helper"

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

  # todo fix test
  test "admin can create a new user" do
    sign_in @admin

    # Print the initial User count before posting
    initial_count = User.count
    puts "Initial User Count: #{initial_count}"

    # Attempt to create a new user and assert the change in count
    assert_difference("User.count", 1) do
      post users_path, params: @new_user_params
    end

    new_user = User.last

    # If creation failed, output errors to help debug
    if new_user.invalid?
      puts "New user errors: #{new_user.errors.full_messages.join(", ")}"
    end

    # Debug: Print the redirect URL after the POST action
    puts "Redirected to: #{response.redirect_url}"

    # Assert that the response redirects to the show page of the newly created user
    assert_redirected_to user_path(new_user)
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