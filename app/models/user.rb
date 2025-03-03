class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_and_belongs_to_many :roles

  after_create :assign_default_role

  private

  def assign_default_role
    default_role = Role.find_or_create_by(name: 'user')
    self.roles << default_role
  end
end
