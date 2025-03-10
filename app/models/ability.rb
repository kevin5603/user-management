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
      # todo: I feel like this code is against the DRY rule, it repeats the DB. But what would be a better approach?
      # even if I turned this into hash map it still not DRY
      # maybe it is a mistake from the very beginning
      case permission.name
      when 'index'
        can :index, User
      when 'show'
        can :show, User
      when 'edit'
        can :edit, User
      when 'update'
        can :update, User
      when 'new'
        can :new, User
      when 'create'
        can :create, User
      when 'destroy'
        can :destroy, User
      when 'update_user_roles'
        can :update_user_roles, User
      end
    end
  end
end
