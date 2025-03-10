class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         # :confirmable

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :phone_number, presence: true

  # validates_plausible_phone :phone_number

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  after_create :assign_default_role

  def full_name
    "#{first_name} #{last_name}"
  end

  def assign_default_role
    self.roles << Role.find_by(name: "user") if self.roles.empty?
  end
end
