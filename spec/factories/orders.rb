FactoryBot.define do
  factory :order do
    sequence(:id)
    association :store
    association :buyer, factory: :user_buyer
  end
end
