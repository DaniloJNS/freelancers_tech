# frozen_string_literal: true

FactoryBot.define do
  factory :proposal do
    justification { FFaker::Lorem.paragraph }
    price_hour { rand(1..10000) }
    weekly_hour { rand(1..44) }
    completion_deadline { rand(1..300) }
    professional
    project
  end
end
