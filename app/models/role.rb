# frozen_string_literal: true

# Role model
class Role < ApplicationRecord
  has_many :user_roles
  has_many :users, through: :user_roles

  has_many :role_permissions, dependent: :destroy
  has_many :permissions, through: :role_permissions

  validates :name, presence: true, uniqueness: true
end
