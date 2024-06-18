FactoryBot.define do
  factory :address do
    street { "Praça da Sé" }
    city { "São Paulo" }
    number { "68" }
    state { "SP" }
    zip_code { "01001-001" }
    country { "Brazil" }

    trait :for_user do
      association :addressable, factory: :user
    end

    trait :for_store do
      association :addressable, factory: :store
    end
  end
end
