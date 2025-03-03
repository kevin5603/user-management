class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  validates :phone_number, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }

  before_save :assign_role

  def assign_role
    self.roles.append(Role.find_by name: 'Regular') if self.roles.empty?
  end
end
