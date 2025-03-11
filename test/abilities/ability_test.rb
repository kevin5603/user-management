require "test_helper"

class AbilityTest < ActiveSupport::TestCase

  test "admin should have full access" do
    admin = FactoryBot.create(:user, :admin)
    ability = Ability.new(admin)

    assert ability.can?(:index, :home)
    assert [:read, :update, :destroy].all? { |action| ability.can?(action, User) }

  end

  test "manager should be able to read users but not edit or destroy another users" do
    manager = FactoryBot.create(:user, :manager)
    ability = Ability.new(manager)

    another_user = FactoryBot.create(:user)

    assert ability.can?(:index, :home)
    assert ability.can?(:read, User)
    assert ability.can?(:update, User, id: manager.id)
    assert ability.cannot?(:update, another_user.id)
    assert ability.cannot?(:destroy, User)
  end

  test "regular user should only access home index and be able to update their own profile." do
    regular_user = FactoryBot.create(:user, :manager)
    ability = Ability.new(regular_user)

    assert ability.can?(:index, :home)
    assert ability.can?(:update, User, id: regular_user.id)
    assert ability.cannot?(:read, :all)
    assert ability.cannot?(:edit, :user)
    assert ability.cannot?(:destroy, :user)
  end
end