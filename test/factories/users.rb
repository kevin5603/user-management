require 'faker'

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email(domain: 'example.com') }
    phone_number { "+1 #{Faker::PhoneNumber.area_code} #{Faker::PhoneNumber.exchange_code} #{Faker::PhoneNumber.subscriber_number(length: 4)}" }
    job_title { Faker::Job.title }
    password { 'password123' }
    password_confirmation { 'password123' }
    confirmed_at { Time.now }

    factory :admin_user do
      after(:create) do |user|
        user.roles << FactoryBot.create(:role, :admin_role)
      end
    end


    factory :manager_user do
      after(:create) do |user|
        user.roles << FactoryBot.create(:role, :manager_role)
      end
    end

    factory :regular_user do
      after(:create) do |user|
        user.roles << create(:role, :regular_user_role)
      end
    end

  end
end