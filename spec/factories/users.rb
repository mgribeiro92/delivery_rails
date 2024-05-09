FactoryBot.define do
  factory :user do
    email { "email_incorrect@example.com" }
    password { "123456" }
    role { "seller" }
  end
end
