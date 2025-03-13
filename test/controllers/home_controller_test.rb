require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'unauthorized user should get redirected' do
    get home_index_path
    assert_response :redirect
  end

  test 'user should get home index' do
    sign_in create(:user)
    get home_index_url
    assert_response :success
  end
end
