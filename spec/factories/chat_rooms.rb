FactoryBot.define do
  factory :chat_room do
    association :buyer, factory: :user_buyer
    association :store
  end
end
