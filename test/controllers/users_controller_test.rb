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
      phone_number: "1234567890",
      password: "password123",
      password_confirmation: "password123",
      confirmed_at: Time.now # If using confirmable
    )
    @admin.roles << @admin_role

    @manager = User.create!(
      first_name: "Manager",
      last_name: "User",
      email: "manager@example.com",
      phone_number: "1234567891",
      password: "password123",
      password_confirmation: "password123",
      confirmed_at: Time.now
    )
    @manager.roles << @manager_role

    @regular_user = User.create!(
      first_name: "Regular",
      last_name: "User",
      email: "user@example.com",
      phone_number: "1234567892",
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
        phone_number: "9876543210",
        password: "password123",
        password_confirmation: "password123"
      }
    }
  end

  # ===== Admin Role Tests =====

  test "admin can access index" do
    sign_in @admin
    get users_path
    assert_response :success
    assert_select "h1", "Users" # Assuming your index has an h1 with "Users"
  end

  test "admin can create user" do
    sign_in @admin
    assert_difference('User.count') do
      post users_path, params: @new_user_params
    end
    assert_redirected_to user_path(User.last)
  end

  test "admin can view user" do
    sign_in @admin
    get user_path(@regular_user)
    assert_response :success
    assert_select "h1", @regular_user.full_name # Assuming your show has an h1 with user's name
  end

  test "admin can edit user" do
    sign_in @admin
    get edit_user_path(@regular_user)
    assert_response :success

    patch user_path(@regular_user), params: { user: { first_name: "Updated" } }
    assert_redirected_to user_path(@regular_user)
    @regular_user.reload
    assert_equal "Updated", @regular_user.first_name
  end

  test "admin can delete user" do
    sign_in @admin
    assert_difference('User.count', -1) do
      delete user_path(@regular_user)
    end
    assert_redirected_to users_path
  end

  # ===== Manager Role Tests =====

  test "manager can access index" do
    sign_in @manager
    get users_path
    assert_response :success
  end

  test "manager cannot create user" do
    sign_in @manager
    assert_no_difference('User.count') do
      post users_path, params: @new_user_params
    end
    assert_redirected_to root_path # Assuming redirect on unauthorized
  end

  test "manager can view user" do
    sign_in @manager
    get user_path(@regular_user)
    assert_response :success
  end

  test "manager cannot edit user" do
    sign_in @manager
    get edit_user_path(@regular_user)
    assert_redirected_to root_path # Assuming redirect on unauthorized

    patch user_path(@regular_user), params: { user: { first_name: "Attempted" } }
    assert_redirected_to root_path
    @regular_user.reload
    assert_not_equal "Attempted", @regular_user.first_name
  end

  test "manager cannot delete user" do
    sign_in @manager
    assert_no_difference('User.count') do
      delete user_path(@regular_user)
    end
    assert_redirected_to root_path
  end

  # ===== Regular User Role Tests =====

  test "regular user cannot access index" do
    sign_in @regular_user
    get users_path
    assert_redirected_to root_path
  end

  test "regular user cannot create user" do
    sign_in @regular_user
    assert_no_difference('User.count') do
      post users_path, params: @new_user_params
    end
    assert_redirected_to root_path
  end

  test "regular user can view own profile" do
    sign_in @regular_user
    get user_path(@regular_user)
    assert_response :success
  end

  test "regular user cannot view other profiles" do
    sign_in @regular_user
    get user_path(@manager)
    assert_redirected_to root_path
  end

  test "regular user can edit own profile" do
    sign_in @regular_user
    get edit_user_path(@regular_user)
    assert_response :success

    patch user_path(@regular_user), params: { user: { phone_number: "5555555555" } }
    assert_redirected_to user_path(@regular_user)
    @regular_user.reload
    assert_equal "5555555555", @regular_user.phone_number
  end

  test "regular user cannot edit other profiles" do
    sign_in @regular_user
    get edit_user_path(@manager)
    assert_redirected_to root_path

    patch user_path(@manager), params: { user: { phone_number: "5555555555" } }
    assert_redirected_to root_path
    @manager.reload
    assert_not_equal "5555555555", @manager.phone_number
  end
end