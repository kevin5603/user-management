class Role < ApplicationRecord
  has_and_belongs_to_many :users

  def self.get_default_role
    find_or_create_by!(name: 'regular_user')
  end
end
