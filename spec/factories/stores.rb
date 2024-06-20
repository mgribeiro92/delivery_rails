FactoryBot.define do
  factory :store do
    sequence(:name) { |n| "Store #{n}" }
    association :user, factory: :user_seller
  end
end
