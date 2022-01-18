# frozen_string_literal: true

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
  has_many :proposals, dependent: :destroy
  has_many :professionals, through: :proposals

  validates :title, :description, :deadline_submission, :max_price_per_hour,
            presence: true, on: :create
  validates :max_price_per_hour, numericality: { greater_than: 0 }
  validate :date_past, on: :create

  enum status: { open: 0, closed: 1, finished: 2 }

  scope :available, -> { where(status: 0) }
  scope :search, lambda { |parameter|
                   where('(title like ? OR description like ?) and
                                         status = ?', "%#{parameter}%", "%#{parameter}%", 0)
                 }
  scope :teams, lambda { |professional|
                  joins(:proposals).where(proposals: { status: 'accepted',
                                                       professional_id: professional.id },
                                          status: 'closed')
                }

  after_initialize :deadline_expired?

  def days_remaining
    return (deadline_submission - Date.current).to_i if Date.current.before? deadline_submission

    0
  end

  def format_max_price_per_hour
    ActiveSupport::NumberHelper.number_to_currency max_price_per_hour
  end

  def average_offer
    return 0 if proposals.average('price_hour').nil?

    proposals.average('price_hour')
  end

  def belongs_to?(resource)
    if resource.instance_of? Professional
      professionals.exists? resource.id
    elsif resource.instance_of? User
      user.eql? resource
    else
      false
    end
  end

  private

  def deadline_expired?
    closed! if deadline_submission.present? && Date.current.after?(deadline_submission)
  end

  def date_past
    errors.add(:deadline_submission, 'não pode está no passado') if !deadline_submission
                                                                    .nil? && deadline_submission.before?(Date.current)
  end
end
