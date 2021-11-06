# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    professional
    name { FFaker::NameBR.name }
    social_name { FFaker::NameBR.first_name }
    description { FFaker::LoremBR.paragraphs }
    age { rand(18..100) }
    birth_date { "#{rand(1..28)}/#{rand(1..12)}/#{rand(1930..2002)}" }
  end
end
