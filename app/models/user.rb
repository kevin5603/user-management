class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :phone_number, presence: true
  # validates_plausible_phone :phone_number  # Uncomment if you're using phonelib

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  after_create :assign_default_role, :notify_admins

  def full_name
    "#{first_name} #{last_name}"
  end

  def assign_default_role
    self.roles << Role.find_by(name: "user") if self.roles.empty?
  end

  private

  def notify_admins
    NewUserNotificationJob.perform_later(self.id)
  end
end