class Project < ApplicationRecord
  belongs_to :user
  has_many :proposal
  has_many :professional, through: :proposal

  validates :title, :description, :deadline_submission, :max_price_per_hour, 
            presence: true, on: :create
  validates :max_price_per_hour, :numericality => { :greater_than => 0 }
  validate :date_past, on: :create

  enum status: { open: 0, closed: 1, finished: 2 }

  def days_remaining
    0
    (deadline_submission - Date.current).to_i if Date.current.before? deadline_submission
  end
  def average_offer
    self.proposal.average("price_hour")
  end

  private
  def date_past
      errors.add(:deadline_submission,
                 'não pode está no passado') if not deadline_submission.nil? and 
                deadline_submission.before? Date.current
  end
end
