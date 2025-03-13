require "test_helper"

class AbilityTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = FactoryBot.create(:user, :admin_user)
    @manager_user = FactoryBot.create(:user, :manager_user)
    @regular_user = FactoryBot.create(:user, :regular_user)
  end


  test "admin can manage all users" do
    ability = Ability.new(@admin_user)

    assert ability.can?(:create, User)
    assert ability.can?(:read, User)
    assert ability.can?(:update, User)
    assert ability.can?(:destroy, User)

    # Admin can manage specific users
    assert ability.can?(:read, @admin_user)
    assert ability.can?(:read, @manager_user)
    assert ability.can?(:read, @regular_user)

    assert ability.can?(:update, @admin_user)
    assert ability.can?(:update, @manager_user)
    assert ability.can?(:update, @regular_user)

    assert ability.can?(:destroy, @admin_user)
    assert ability.can?(:destroy, @manager_user)
    assert ability.can?(:destroy, @regular_user)

    # Admin can update role_ids
    assert ability.can?(:update, User.new, :role_ids)
  end

  # Manager tests
  test "manager can read all users" do
    ability = Ability.new(@manager_user)

    assert ability.can?(:read, User)
    assert ability.can?(:read, @admin_user)
    assert ability.can?(:read, @manager_user)
    assert ability.can?(:read, @regular_user)
  end

  test "manager can only update themselves" do
    ability = Ability.new(@manager_user)

    assert ability.can?(:update, @manager_user)
    assert_not ability.can?(:update, @admin_user)
    assert_not ability.can?(:update, @regular_user)
  end

  test "manager cannot create or destroy users" do
    ability = Ability.new(@manager_user)

    assert_not ability.can?(:create, User)
    assert_not ability.can?(:destroy, User)
    assert_not ability.can?(:destroy, @admin_user)
    assert_not ability.can?(:destroy, @manager_user)
    assert_not ability.can?(:destroy, @regular_user)
  end

  # Regular user tests
  test "regular user can only read and update themselves" do
    ability = Ability.new(@regular_user)

    assert ability.can?(:read, @regular_user)
    assert ability.can?(:update, @regular_user)

    assert_not ability.can?(:read, @admin_user)
    assert_not ability.can?(:read, @manager_user)

    assert_not ability.can?(:update, @admin_user)
    assert_not ability.can?(:update, @manager_user)
  end

  test "regular user cannot create or destroy users" do
    ability = Ability.new(@regular_user)

    assert_not ability.can?(:create, User)
    assert_not ability.can?(:destroy, User)
    assert_not ability.can?(:destroy, @admin_user)
    assert_not ability.can?(:destroy, @manager_user)
    assert_not ability.can?(:destroy, @regular_user)
  end
end
