FactoryBot.define do
  factory :product, class: Product do
    sequence(:title) { |n| "Product #{n}" }
    price { rand(1.0..100.0).round(2) }
    association :store, factory: :store
  end

  factory :product2, class: Product do
    title { "Pizza Calabresa" }
    price { 35 }
    association :store, factory: :store2
  end
end
