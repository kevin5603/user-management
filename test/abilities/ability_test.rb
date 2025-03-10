require "test_helper"

class AbilityTest < ActiveSupport::TestCase

  test "admin should have full access" do
    admin = FactoryBot.create(:user, :admin)
    ability = Ability.new(admin)

    assert ability.can?(:index, :home)
    assert [:read, :update, :destroy].all? { |action| ability.can?(action, User) }

  end

  test "manager should be able to read users but not edit or destroy" do
    manager = FactoryBot.create(:user, :manager)
    ability = Ability.new(manager)

    assert ability.can?(:index, :home)
    assert ability.can?(:read, User)
    assert ability.cannot?(:update, User)
    assert ability.cannot?(:destroy, User)
  end

  test "regular user should only access home index" do
    regular_user = FactoryBot.create(:user, :manager)
    ability = Ability.new(regular_user)

    assert ability.can?(:index, :home)
    assert ability.cannot?(:read, :all)
    assert ability.cannot?(:edit, :user)
    assert ability.cannot?(:destroy, :user)
  end
end