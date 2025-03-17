class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  validates :user, uniqueness: { scope: :role_id }
end
