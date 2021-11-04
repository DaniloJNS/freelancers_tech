FactoryBot.define do
  factory :project do
    title { "Blog samurai" }
    description { "Um blog massa sobre samirais em rails" }
    deadline_submission { 1.week.from_now }
    remote { true }
    max_price_per_hour { 300 }
    user
  end
end
