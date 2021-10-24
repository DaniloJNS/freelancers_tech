class Project < ApplicationRecord
  belongs_to :user
  has_many :proposals
  has_many :professionals, through: :proposals

  validates :title, :description, :deadline_submission, :max_price_per_hour, 
            presence: true, on: :create
  validates :max_price_per_hour, :numericality => { :greater_than => 0 }
  validate :date_past, on: :create

  enum status: { open: 0, closed: 1, finished: 2 }

  def days_remaining
    return (deadline_submission - Date.current).to_i if Date.current.before? deadline_submission
    0
  end
  def average_offer
    return 0 if proposals.average("price_hour").nil?
    
    proposals.average("price_hour")
  end
  def belongs_to? resource
    if resource.instance_of? Professional
      professionals.exists? resource.id
    elsif resource.instance_of? User
      user.eql? resource
    else
      false
    end
  end
  private
  def date_past
    errors.add(:deadline_submission,'não pode está no passado') if not deadline_submission
          .nil? and deadline_submission.before? Date.current
  end
end
