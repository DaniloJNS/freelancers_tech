class Project < ApplicationRecord
  belongs_to :user

  validates :title, :description, :deadline_submission, :max_price_per_hour, 
            presence: true

  validates :max_price_per_hour, :numericality => { :greater_than => 0 }
  validate :date_past

  private
  def date_past
      errors.add(:deadline_submission,
                 'não pode está no passado') if not deadline_submission.nil? and 
                Date.current > deadline_submission
  end
end
