class Project < ApplicationRecord
  belongs_to :user

  validates :title, :description, :deadline_submission, :max_price_per_hour, 
            presence: true

  validates :max_price_per_hour, :numericality => { :greater_than => 0 }
end
