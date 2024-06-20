FactoryBot.define do
  factory :user_admin, class: User do
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    role { 'admin' }
  end

  factory :user_seller, class: User do
    sequence(:email) { |n| "seller#{n}@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    role { "seller" }
  end

  factory :user_buyer, class: User do
    sequence(:email) { |n| "buyer#{n}@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    role { "buyer" }
  end

end
