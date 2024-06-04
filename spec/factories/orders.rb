FactoryBot.define do
  factory :order do
    sequence(:id)
    association :store, factory: :store
    association :buyer, factory: :user_buyer
  end

  factory :order2, class: Order do
    association :store, factory: :store2
    association :buyer, factory: :buyer1
  end
end
