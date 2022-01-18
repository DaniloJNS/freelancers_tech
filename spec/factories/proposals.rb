# frozen_string_literal: true

FactoryBot.define do
  factory :proposal do
    justification { FFaker::Lorem.paragraph }
    price_hour { rand(1..10_000) }
    weekly_hour { rand(1..44) }
    completion_deadline { rand(1..300) }
    professional
    project
    transient do
      project_closed { false }
    end
    after(:create) do |proposal, evaluator|
      proposal.project.closed! if evaluator.project_closed
    end
  end
end
