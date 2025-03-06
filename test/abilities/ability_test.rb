require "test_helper"

class AbilityTest < ActiveSupport::TestCase

  test "admin should have full access" do
    ability = Ability.new(users(:admin_user))

    assert ability.can?(:index, :home)
    assert ability.can?(:manage, :all)
  end

  test "manager should be able to read users but not edit or destroy" do
    ability = Ability.new(users(:manager_user))

    assert ability.can?(:index, :home)
    assert ability.can?(:read, :user)
    assert ability.cannot?(:edit, :user)
    assert ability.cannot?(:destroy, :user)
  end

  test "regular user should only access home index" do
    ability = Ability.new(users(:regular_user))

    assert ability.can?(:index, :home)
    assert ability.cannot?(:read, :all)
    assert ability.cannot?(:edit, :user)
    assert ability.cannot?(:destroy, :user)
  end
end