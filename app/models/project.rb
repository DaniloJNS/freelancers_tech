class Project < ApplicationRecord
  belongs_to :user
  has_many :proposal
  has_many :professional, through: :proposal
  validates :title, :description, :deadline_submission, :max_price_per_hour, 
            presence: true
  validates :max_price_per_hour, :numericality => { :greater_than => 0 }
  validate :date_past
  private
  def date_past
      errors.add(:deadline_submission,
                 'não pode está no passado') if not deadline_submission.nil? and 
                deadline_submission.before? Date.current
  end
end
