# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@mail.com" }
    password { '123123' }
  end
end
