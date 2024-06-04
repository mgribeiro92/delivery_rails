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

  factory :buyer1, class: User do
    email { "buyer_01@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    role { "buyer" }
  end

  factory :seller1, class: User do
    email { "seller_01@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    role { "seller" }
  end

  factory :seller2, class: User do
    email { "seller_02@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    role { "seller" }
  end

  factory :seller3, class: User do
    email { "seller_03@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    role { "seller" }
  end
end
