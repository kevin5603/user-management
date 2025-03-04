require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin_user)
    sign_in @user
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { email: @user.email, first_name: @user.first_name, job_title: @user.job_title, last_name: @user.last_name, phone_number: @user.phone_number } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { email: @user.email, first_name: @user.first_name, job_title: @user.job_title, last_name: @user.last_name, phone_number: @user.phone_number } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_equal User.count, 3
    delete user_url(@user)
    assert_equal User.count, 2
    assert_redirected_to users_url
  end
end
