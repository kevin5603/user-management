require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  include Devise::Test::IntegrationHelpers

  test "unconfirmed user cannot access index (requires email confirmation)" do
    sign_in users(:unconfirmed_user)

    get users_path

    assert_response :redirect
    assert_equal "You have to confirm your email address before continuing.", flash[:alert]
  end

  test "unconfirmed user cannot access edit page (requires login)" do
    @unconfirmed_user = users(:unconfirmed_user)

    get edit_user_path(@unconfirmed_user.id)

    assert_response :redirect
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  test "guest user is redirected when accessing index" do
    get users_path

    assert_response :redirect
    assert_equal "You need to sign in or sign up before continuing.", flash[:alert]
  end

  test "regular user is denied access to index" do
    sign_in users(:regular_user)

    get users_path
    assert_response :redirect
    follow_redirect!
    assert_match "You are not authorized to access this page.", response.body
  end

  test "manager access index" do
    sign_in users(:manager_user)

    get users_path

    assert_response :success
    assert_select "title", text: "UserManagement"
    assert_select "table"
    assert_select "tbody tr", count: User.count
  end

  test "manager cannot edit user (access denied)" do
    manager = users(:manager_user)
    user_to_edit = users(:regular_user)

    sign_in manager
    get edit_user_path(user_to_edit.id)

    assert_response :redirect
    follow_redirect!
    assert_match "You are not authorized to access this page.", response.body
  end

  test "manager cannot delete user (access denied)" do
    manager = users(:manager_user)
    user_to_delete = users(:regular_user)

    sign_in manager
    assert_no_difference "User.count" do
      delete user_path(user_to_delete.id)
    end

    assert_response :redirect
    follow_redirect!
    assert_match "You are not authorized to access this page.", response.body
  end

  test "admin can access index" do
    sign_in users(:admin_user)

    get users_path

    assert_response :success
    assert_select "title", text: "UserManagement"
    assert_select "table"
    assert_select "tbody tr", count: User.count
  end

  test "admin can access edit user page" do
    admin = users(:admin_user)
    sign_in admin

    user_to_edit = users(:regular_user)

    get edit_user_path(user_to_edit.id)

    assert_response :success
    assert_select "h2", text: "Edit User"
    assert_select "input#user_email[value=?]", user_to_edit.email
    assert_select "input#user_first_name[value=?]", user_to_edit.first_name
    assert_select "input#user_last_name[value=?]", user_to_edit.last_name
    assert_select "input#user_phone_number[value=?]", user_to_edit.phone_number
    assert_select "input#user_job_title[value=?]", user_to_edit.job_title
    user_to_edit.roles.each do |role|
      assert_select "input[type=checkbox][name='user[role_ids][]'][value=?][checked=checked]", role.id
    end

  end

  test "admin can edit user" do
    admin = users(:admin_user)
    user_to_edit = users(:regular_user)
    updated_params = {
      user: {
        first_name: "UpdatedFirst",
        last_name: "UpdatedLast",
        phone_number: "0987654321",
        job_title: "Updated Job",
        role_ids: [2, 3]
      }
    }
    sign_in admin

    patch user_path(user_to_edit), params: updated_params
    assert_redirected_to users_path
    follow_redirect!

    user_to_edit.reload
    assert_equal updated_params[:user][:first_name], user_to_edit.first_name
    assert_equal updated_params[:user][:last_name], user_to_edit.last_name
    assert_equal updated_params[:user][:phone_number], user_to_edit.phone_number
    assert_equal updated_params[:user][:job_title], user_to_edit.job_title
    assert_equal updated_params[:user][:role_ids], user_to_edit.roles.map(&:id)

  end

  test "admin can delete user" do
    admin = users(:admin_user)
    user_to_delete = users(:regular_user)

    sign_in admin
    assert_difference "User.count", -1 do
      delete user_path(user_to_delete.id)
    end

    assert_redirected_to users_path
    follow_redirect!
    assert_match "User deleted successfully.", response.body
  end

end
