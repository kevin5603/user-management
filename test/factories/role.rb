FactoryBot.define do
  factory :role do
    trait :admin do
      name { "admin" }
    end

    trait :manager do
      name { "manager" }
    end
  end
end