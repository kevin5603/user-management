# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    elsif user.manager?
      can :read, User
      can :update, User, id: user.id
    else
      can [:read, :update], User, id: user.id
    end
  end
end
