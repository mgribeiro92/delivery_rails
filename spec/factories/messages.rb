FactoryBot.define do
  factory :message do
    content { "MyText" }
    sent_at { "2024-06-14 13:02:53" }
    sender { nil }
    chat_rooms { nil }
  end
end
