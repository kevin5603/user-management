require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # ----------------------------------------
  # Not sign in
  # ----------------------------------------

  test 'not signed in user should redirect to login' do
    get users_path
    assert_response :redirect
  end

  # ----------------------------------------
  # Regular user
  # ----------------------------------------
  test 'regular user should not get index and get access denied' do
    sign_in FactoryBot.create(:user)

    get users_path
    assert_redirected_to access_denied_path
  end

  test 'regular user should view self-profile' do
    user = FactoryBot.create(:user)
    sign_in user

    get user_path user
    assert_response :success
  end

  test 'regular user should edit registration' do
    user = FactoryBot.create(:user)
    sign_in user

    get edit_user_registration_path user
    assert_response :success
  end

  # ----------------------------------------
  # Manager
  # ----------------------------------------
  test 'manger should get index' do
    manager = FactoryBot.create(:user, :manager)
    sign_in manager

    get users_path
    assert_response :success
  end

  test 'manger should not edit others' do
    manager = FactoryBot.create(:user, :manager)
    other_user = FactoryBot.create(:user)

    sign_in manager
    updated_params = {
      first_name: manager.first_name
    }
    patch user_path(other_user), params: { user: updated_params }
    assert_response :redirect
    assert_not_equal other_user.first_name, manager.first_name
  end

  # ----------------------------------------
  # Admin
  # ----------------------------------------
  test 'admin should get index' do
    sign_in FactoryBot.create(:user, :admin)

    get users_path
    assert_response :success
  end

  test 'admin should get new' do
    sign_in FactoryBot.create(:user, :admin)
    get new_user_path
    assert_response :success
  end

  test 'admin should get edit' do
    sign_in FactoryBot.create(:user, :admin)
    user = FactoryBot.create(:user)

    get edit_user_path user
    assert_response :success
  end

  test 'admin should create user' do
    sign_in FactoryBot.create(:user, :admin)
    assert_difference('User.count') do
      post users_path, params: { user: FactoryBot.attributes_for(:user) }
    end
  end

  test 'admin should destroy user' do
    sign_in FactoryBot.create(:user, :admin)
    user = FactoryBot.create(:user)
    assert_difference('User.count', -1) do
      delete user_path(user)
    end
  end

  test 'admin should update any user and roles' do
    admin = FactoryBot.create(:user, :admin)
    user_to_edit = FactoryBot.create(:user)

    sign_in admin
    updated_params = {
      first_name: admin.first_name,
      role_ids: [admin.roles.first.id]
    }

    patch user_path(user_to_edit.id), params: { user: updated_params }
    assert_redirected_to user_path(user_to_edit)

    user_to_edit.reload
    assert_equal admin.first_name, user_to_edit.first_name
    assert_equal admin.roles.first, user_to_edit.roles.first
  end

end
