FactoryBot.define do
  factory :order_item do
    sequence(:id)
    amount { rand(1.0..10.0) }
    association :product
    association :order
  end
end
