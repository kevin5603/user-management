# test/factories/roles.rb
FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "role_#{n}" }

    trait :admin_role do
      name { "admin" }

      # Override the default create strategy for this trait
      initialize_with { Role.find_or_create_by(name: "admin") }
    end

    trait :manager_role do
      name { "manager" }

      # Override the default create strategy for this trait
      initialize_with { Role.find_or_create_by(name: "manager") }
    end

    trait :regular_user_role do
      name { "user" }

      # Override the default create strategy for this trait
      initialize_with { Role.find_or_create_by(name: "user") }
    end
  end
end