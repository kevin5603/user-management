require "test_helper"
require "minitest/mock"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @manager_role = create(:role, :manager_role)
    @user_role = create(:role, :regular_user_role)

    @admin = create(:admin_user)
    @manager = create(:manager_user)
    @regular_user = create(:regular_user)

    @new_user_params = {
          user: attributes_for(:user).merge(
            role_ids: [@user_role.id]
          )
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