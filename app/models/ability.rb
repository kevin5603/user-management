# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    roles = user.roles.pluck(:name)  # Fetch roles once

    if roles.include?('admin')
      can :manage, :all
    elsif roles.include?('manager')
      can :read, User
      can :update, User , :id => user.id
    else
      can [:read, :update], User, id: user.id
    end
  end
end
