# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  validates :phone_number, format: {
    with: /\A\+?[\d\s\-()]{10,15}\z/,
    message: 'must be a valid phone number',
    allow_nil: true
  }

  after_create :notify_admins

  private

  def notify_admins
    RegistrationNotificationEmailJob.perform_async(id)
  end
end
