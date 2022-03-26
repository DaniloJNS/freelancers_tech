# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id              :integer          not null, primary key
#  name            :string
#  social_name     :string
#  description     :string
#  birth_date      :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  professional_id :integer          not null
#  age             :integer
#
class Profile < ApplicationRecord
  belongs_to :professional
  has_many :formations, dependent: :destroy
  has_many :experiences, dependent: :destroy
  validates :name, :description, :birth_date, presence: true
  validate :legal_age

  enum gender: %w[male female]

  before_validation :current_age

  def first_name
    name.split.first
  end

  def self.translation_genders
    genders.transform_keys { |key| human_enum_name(:gender, key) }.to_a
  end

  def last_name
    _, *last_name = name.split
    last_name.join(' ')
  end

  private

  def current_age
    self.age ||= Date.current.year.to_i - birth_date.year.to_i if birth_date.present?
    self.age -= 1 if birth_date.present? && !after_birthday?
  end

  def after_birthday?
    Date.current.month.to_i > birth_date.month.to_i ||
            Date.current.month.to_i == birth_date.month.to_i && Date.current.day.to_i >= birth_date.day.to_i
  end

  def legal_age
    return unless age.present? && (age < 18)
    errors.add(:age, 'deve ter idade maior que 18 anos')
  end
end
