FactoryBot.define do
  factory :role do
    trait :admin_role do
      name { "Admin" }
    end

    trait :manager_role do
      name { "Manager" }
    end

    trait :regular_role do
      name { "Regular" }
    end
  end
end