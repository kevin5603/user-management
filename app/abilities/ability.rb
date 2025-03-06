# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, :home
    return unless user.present?

    @roles = user.roles.map(&:name)
    if @roles.include?('admin')
      can :manage, :all
    end
    if @roles.include?('manager')
      can :read, :user
    end
  end
end
