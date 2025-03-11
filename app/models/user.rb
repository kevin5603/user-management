class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_and_belongs_to_many :roles

  validates_format_of :phone_number, with: /\A09[0-9]{8}\z/, allow_blank: true

  after_create :assign_default_role, :notify_admin

  scope :with_role, ->(role_name) { joins(:roles).where(roles: { name: role_name }) }


  private

  def assign_default_role
    default_role = Role.get_default_role
    self.roles << default_role unless self.roles.include?(default_role)
  end

  def notify_admin
    RegistrationNotificationJob.perform_async(self.id)
  end
end
