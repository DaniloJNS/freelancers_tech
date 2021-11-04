FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { "123123123" }
  end
end

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@email.com"
  end
end
