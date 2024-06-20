FactoryBot.define do
  factory :product, class: Product do
    sequence(:title) { |n| "Product #{n}" }
    price { rand(1.0..100.0).round(2) }
    inventory { rand(1..30) }
    association :store
  end
end
