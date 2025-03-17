require "test_helper"

class RoleTest < ActiveSupport::TestCase

  test 'name should be required' do
    assert_not Role.new.valid?
  end

  test 'name should be unique' do
    assert Role.create!(name: 'test')
    assert_not Role.new(name: 'test').valid?
  end

  test 'should be able have multiple permissions' do
    index_user_permission = Permission.find(ActiveRecord::FixtureSet.identify(:index_users))
    show_user_permission = Permission.find(ActiveRecord::FixtureSet.identify(:show_users))

    assert Role.create!(name: 'test', permissions: [index_user_permission, show_user_permission])
  end
end
