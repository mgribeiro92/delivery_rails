FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "Store #{n}" }
    association :user, factory: :user_seller
  end

  factory :store2, class: Store do
    name { "Great Store"}
    association :user, factory: :seller3
  end
end
