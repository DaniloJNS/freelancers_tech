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
  has_many :formations
  has_many :experiences
  validates :name, :description, :birth_date, presence: true
  validate :legal_age

  before_validation do
    if birth_date.present?
      self.age ||= Date.current.year.to_i - birth_date.year.to_i
    end
  end

  private
  def legal_age
      errors.add(:age,
                 'deve ser maior que 18 anos') if age.present? and 
                18 > age
  end
end
