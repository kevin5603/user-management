require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "public page is accessible without login" do
    get root_url
    assert_response :success
  end

end
