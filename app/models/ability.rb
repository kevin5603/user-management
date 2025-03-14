# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # default permission for regular user
    if user.id
      can :show, User, id: user.id
      can :edit, User, id: user.id
      can :update, User, id: user.id
    end

    return if user.roles.empty?

    permissions = user.roles.map(&:permissions).flatten.uniq
    permissions.each do |permission|
      can permission.name.to_sym, User
    end
  end
end
