class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_and_belongs_to_many :roles

  validates_format_of :phone_number, with: /\A09[0-9]{8}\z/, allow_blank: true

  after_create :assign_default_role, :notify_admin

  private

  def assign_default_role
    default_role = Role.find_or_create_by(name: 'regular_user')
    self.roles << default_role
  end

  def notify_admin
    RegistrationNotificationJob.perform_async(self.email, self.first_name, self.last_name)
  end
end
