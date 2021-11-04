# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  title               :string
#  description         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  deadline_submission :date
#  user_id             :integer          not null
#  remote              :boolean          default(FALSE)
#  max_price_per_hour  :decimal(, )
#  status              :integer          default("open")
#
class Project < ApplicationRecord
  belongs_to :user
  has_many :proposals
  has_many :professionals, through: :proposals

  validates :title, :description, :deadline_submission, :max_price_per_hour, 
            presence: true, on: :create
  validates :max_price_per_hour, :numericality => { :greater_than => 0 }
  validate :date_past, on: :create

  enum status: { open: 0, closed: 1, finished: 2 }

  scope :available, -> { where(status: 0) }
  scope :search, -> (parameter) { where('(title like ? OR description like ?) and 
                                       status = ?', "%#{parameter}%", "%#{parameter}%", 0) }
  
  after_initialize :is_closed?

  def days_remaining
    return (deadline_submission - Date.current).to_i if Date.current.before? deadline_submission
    0
  end
  def average_offer
    return 0 if proposals.average("price_hour").nil?
    proposals.average("price_hour")
  end
  def belongs_to? resource
    false
    if resource.instance_of? Professional
      professionals.exists? resource.id
    elsif resource.instance_of? User
      user.eql? resource
    end
  end
  private
  def is_closed?
    closed! if deadline_submission.present? and Date.current.after? deadline_submission
  end
  def date_past
    errors.add(:deadline_submission,'não pode está no passado') if not deadline_submission
          .nil? and deadline_submission.before? Date.current
  end
end
