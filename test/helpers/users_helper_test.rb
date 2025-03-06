require "test_helper"

class UsersHelperTest < ActionView::TestCase
  test "resource_name should return :user" do
    assert_equal :user, resource_name
  end

  test "resource should return a new User instance" do
    assert_instance_of User, resource
  end

  test "devise_mapping should return Devise mapping for :user" do
    assert_equal Devise.mappings[:user], devise_mapping
  end
end