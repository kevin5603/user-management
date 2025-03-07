# frozen_string_literal: true
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :phone_number, format: {
    with: /\A\+?[\d\s\-()]{10,15}\z/,
    message: 'must be a valid phone number',
    allow_nil: true
  }
end
