FactoryBot.define do
  factory :professional do
    email { FFaker::Internet.email }
    password { '123123123' }
  end
end
