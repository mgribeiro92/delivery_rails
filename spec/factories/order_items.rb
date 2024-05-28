FactoryBot.define do
  factory :order_item do
    sequence(:id)
    amount { rand(1.0..10.0) }
    price { rand(1.0..50.0).round(2) }
    association :product, factory: :product2
    association :order, factory: :order2
  end
end
