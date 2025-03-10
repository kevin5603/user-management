# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # Guest user (not logged in)

    if user.roles.exists?(name: 'admin')
      can :manage, :all  # Admins can manage everything
    elsif user.roles.exists?(name: 'manager')
      can :read, User  # Managers can only view users
    else
      can :read, User, id: user.id  # Regular users can only view their own profile
    end
    # user ||= User.new # Guest user (not logged in)
    #
    # if user.roles.exists?(name: 'admin')
    #   can :manage, User  # Admins can create, update, and delete users
    # elsif user.roles.exists?(name: 'manager')
    #   can :read, User  # Managers can only view users
    # else
    #   can :read, User, id: user.id  # Regular users can only view their own profile
    # end
  end
end
