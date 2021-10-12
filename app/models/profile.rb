class Profile < ApplicationRecord
  belongs_to :professional
  validates :name, :description, :birth_date, presence: true
end
