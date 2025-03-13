
FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    confirmed_at { Time.current }

    trait :regular_user do
    end

    trait :manager do
      after(:create) do |user|
        user.roles << Role.find(ActiveRecord::FixtureSet.identify(:manager))
      end
    end

    trait :admin do
      after(:create) do |user|
        user.roles << Role.find(ActiveRecord::FixtureSet.identify(:admin))
      end
    end
  end
end
