require "test_helper"

class ErrorsControllerTest< ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers


  test 'should get access denied page' do
    get access_denied_url
    assert_response :success
  end
end
