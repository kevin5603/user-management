class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validate :validate_phone_number

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  after_create :assign_default_role, :notify_admins

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def assign_default_role
    user_role = Role.find_or_create_by(name: "user")
    self.roles << user_role if user_role.present? && self.roles.empty?
  end

  def validate_phone_number
    if phone_number.blank?
      errors.add(:phone_number, "can't be blank")
      return
    end

    parsed_number = Phonelib.parse(phone_number)

    unless parsed_number.valid?
      error_message = if parsed_number.possible?
                        "is not a valid phone number for the selected country."
                      else
                        "is not formatted correctly or too short/long."
                      end
      errors.add(:phone_number, error_message)
    end
  end

  private

  def notify_admins
    if Role.exists?(name: "admin")
      NewUserNotificationJob.perform_later(self.id)
    end
  end
end