class Profile < ApplicationRecord
  belongs_to :professional
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
