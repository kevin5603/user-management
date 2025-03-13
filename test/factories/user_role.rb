FactoryBot.define do
  factory :user_role do
    # Use associations instead of hardcoded IDs
    association :user
    association :role

    factory :admin_user_role do
      association :user, factory: :user
      association :role, factory: [:role, :admin_role]
    end

    factory :manager_user_role do
      association :user, factory: :user
      association :role, factory: [:role, :manager_role]
    end

    factory :regular_user_role do
      association :user, factory: :user
      association :role, factory: [:role, :regular_role]
    end
  end
end