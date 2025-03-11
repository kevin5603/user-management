require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.default_url_options[:host] = 'localhost:3000'

    @user = FactoryBot.create(:user, :admin_user)
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
    user_attributes = FactoryBot.attributes_for(:user)
    before_count = User.count

    post users_url, params: { user: user_attributes }

    after_count = User.count
    assert_equal before_count + 1, after_count, "User count should increase by 1"

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
    admin = FactoryBot.create(:user, :admin_user)
    user_to_delete = FactoryBot.create(:user)

    sign_in admin
    assert_difference "User.count", -1 do
      delete user_path(user_to_delete.id)
    end

    assert_redirected_to users_path
  end
end
