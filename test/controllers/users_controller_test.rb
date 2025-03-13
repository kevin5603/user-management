require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    ActionMailer::Base.default_url_options[:host] = 'localhost:3000'
  end

  test "admin should be able to get index" do
    user = FactoryBot.create(:user, :admin_user)
    sign_in user
    get users_url
    assert_response :success
  end

  test "admin should be able to get new" do
    user = FactoryBot.create(:user, :admin_user)
    sign_in user
    get new_user_url
    assert_response :success
  end

  test "admin should be able to create user" do
    admin_user = FactoryBot.create(:user, :admin_user)
    sign_in admin_user

    user_attributes = FactoryBot.attributes_for(:user)
    before_count = User.count

    post users_url, params: { user: user_attributes }

    after_count = User.count
    assert_equal before_count + 1, after_count, "User count should increase by 1"

    assert_redirected_to user_url(User.last)
  end

  test "admin should be able to show user" do
    user = FactoryBot.create(:user, :admin_user)
    sign_in user

    get user_url(user)
    assert_response :success
  end

  test "admin should be able to get edit" do
    user = FactoryBot.create(:user, :admin_user)
    sign_in user

    get edit_user_url(user)
    assert_response :success
  end

  private
  def generate_updated_admin_user_params
    admin_role = Role.find_by(name: 'Admin')
    updated_params = {
      user: {
        first_name: "UpdatedFirst",
        last_name: "UpdatedLast",
        phone_number: "0987654321",
        job_title: "Updated Job",
        role_ids: [admin_role.id]
      }
    }
  end

  test "admin should be able to update user" do
    admin = FactoryBot.create(:user, :admin_user)
    regular_user = FactoryBot.create(:user, :regular_user)
    updated_params = generate_updated_admin_user_params

    sign_in admin
    patch user_path(regular_user), params: updated_params
    assert_redirected_to user_url(User.last)
  end

  test "regular should not be able to update user" do
    regular_user = FactoryBot.create(:user, :regular_user)
    admin_role = Role.find_or_create_by!(name: 'Admin')
    updated_params = generate_updated_admin_user_params

    sign_in regular_user
    patch user_path(regular_user), params: updated_params
    regular_user.reload

    assert_equal "UpdatedFirst", regular_user.first_name
    assert regular_user.roles.exclude?(admin_role), "Regular user should not be able to assign admin role"
    assert_redirected_to user_url(User.last)
  end

  test "manager should not be able to update user" do
    manager_user = FactoryBot.create(:user, :manager_user)
    admin_role = Role.find_or_create_by!(name: 'Admin')
    updated_params = generate_updated_admin_user_params

    sign_in manager_user
    patch user_path(manager_user), params: updated_params
    manager_user.reload

    assert_equal "UpdatedFirst", manager_user.first_name
    assert manager_user.roles.exclude?(admin_role), "Regular user should not be able to assign admin role"
    assert_redirected_to user_url(User.last)
  end

  test "admin should be able to destroy user" do
    admin = FactoryBot.create(:user, :admin_user)
    user_to_delete = FactoryBot.create(:user, :regular_user)

    sign_in admin
    assert_difference "User.count", -1 do
      delete user_path(user_to_delete.id)
    end

    assert_redirected_to users_path
  end
end
