# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :index, :home
    return unless user.present?

    @roles = user.roles.pluck(:name)
    if @roles.include?('regular_user')
      can [:show, :update], User, id: user.id
    end
    if @roles.include?('manager')
      can :read, User
    end
    if @roles.include?('admin')
      can [:read, :update, :destroy], User
    end
  end
end
