require "test_helper"

class AbilityTest < ActiveSupport::TestCase

  def setup
    @other_user = create(:user)
  end

  test 'regular user ability' do
    regular_user = FactoryBot.create(:user)
    ability = Ability.new(regular_user)

    assert ability.can?(:show, regular_user)
    assert ability.can?(:edit, regular_user)
    assert ability.can?(:update, regular_user)

    assert ability.cannot?(:index, regular_user)
    assert ability.cannot?(:update_user_roles, regular_user)
    assert ability.cannot?(:show, @other_user)
    assert ability.cannot?(:edit, @other_user)
    assert ability.cannot?(:update, @other_user)
    assert ability.cannot?(:destroy, @other_user)
  end

  test 'manger ability' do
    manager = FactoryBot.create(:user, :manager)
    ability = Ability.new(manager)

    assert ability.can?(:index, User)
    assert ability.can?(:show, manager)
    assert ability.can?(:show , @other_user)
    assert ability.can?(:edit, manager)
    assert ability.can?(:update, manager)

    assert ability.cannot?(:edit, @other_user)
    assert ability.cannot?(:update, @other_user)
    assert ability.cannot?(:destroy, @other_user)
  end

  test 'admin ability' do
    admin = FactoryBot.create(:user, :admin)
    ability = Ability.new(admin)

    assert ability.can?(:index, User)
    assert ability.can?(:show, @other_user)
    assert ability.can?(:edit, @other_user)
    assert ability.can?(:update, @other_user)
    assert ability.can?(:new, @other_user)
    assert ability.can?(:create, @other_user)
    assert ability.can?(:destroy, @other_user)
    assert ability.can?(:update_user_roles, @other_user)
  end
end
