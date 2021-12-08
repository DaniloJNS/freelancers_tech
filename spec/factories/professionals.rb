# frozen_string_literal: true

FactoryBot.define do
  factory :professional do
    sequence(:email) { |n| "freelancer#{n}@mail.com" }
    password { '123123' }
    profile { association :profile, professional: instance }
  end
end
