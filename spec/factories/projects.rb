FactoryBot.define do
  factory :project do
    title { FFaker::Lorem.phrase }
    description { FFaker::Lorem.paragraph }
    deadline_submission { "#{rand(1..28)}/#{rand(1..12)}/#{(Date.current.year + 1)..2025}" }
    remote { true }
    max_price_per_hour { rand(100..30_000) }
    status { 'open' }
    user
  end
end
