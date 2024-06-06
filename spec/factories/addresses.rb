FactoryBot.define do
  factory :address do
    addressable { nil }
    street { "MyString" }
    number { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip_code { "MyString" }
    country { "MyString" }
    latitude { 1.5 }
    longitude { 1.5 }
  end
end
