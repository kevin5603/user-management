FactoryBot.define do
  factory :user do
    # Basic attributes
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    phone_number { '0912345678' }
    password { 'password123' }
    confirmed_at { Time.current }

    trait :admin_user do
      job_title { 'Admin' }

      after(:create) do |user|
        user.roles.clear
        user.roles << Role.find_or_create_by(name: 'Admin')
      end
    end

    trait :manager_user do
      job_title { 'Manager' }

      after(:create) do |user|
        user.roles << Role.find_or_create_by(name: 'Manager')
      end
    end

    trait :regular_user do
      job_title { 'SE' }

      after(:create) do |user|
        user.roles << Role.find_or_create_by(name: 'Regular')
      end
    end
  end
end