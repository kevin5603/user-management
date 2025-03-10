FactoryBot.define do
  factory :user do
    email {Faker::Internet.email}
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    phone_number { '0912345678' }
    password { "p@ssw0rd" }
    confirmed_at { Time.current }

    trait :admin do
      job_title { "Administration" }
      after(:create) do |user|
        user.roles << Role.find_or_create_by!(name: 'admin')
      end
    end

    trait :manager do
      job_title { "Management" }
      after(:create) do |user|
        user.roles << Role.find_or_create_by!(name: 'manager')
      end
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end

  end
end