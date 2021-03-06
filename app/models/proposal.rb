# frozen_string_literal: true

# == Schema Information
#
# Table name: proposals
#
#  id                  :integer          not null, primary key
#  justification       :text
#  price_hour          :decimal(, )
#  weekly_hour         :integer
#  completion_deadline :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  professional_id     :integer          not null
#  project_id          :integer          not null
#  status              :integer          default("pending")
#  feedback            :string
#  deadline_cancel     :date
#
class Proposal < ApplicationRecord
  belongs_to :professional
  belongs_to :project

  validates :justification, :price_hour, :weekly_hour, :completion_deadline,
            presence: true
  validates :price_hour, :weekly_hour, :completion_deadline, numericality: { only: true,
                                                                             greater_than: 0 }
  validate :presence_feedback_on_refused, :duplicate_feeedback, :presence_feedback_on_cancel,
           on: :update
  validate :block_new_proposals_if_not_open, on: :create

  enum status: { pending: 0, accepted: 1, refused: 2, cancel: 3 }
  scope :count_status, ->(parameter) { where(status: parameter).count }
  scope :available, -> { where('status<> 4 or feedback is not ?', nil) }

  before_save :deadline_for_cancel_in_accepted

  def belongs_to?(resource)
    if resource.instance_of? User
      project.user.eql? resource
    elsif resource.instance_of? Professional
      professional.eql? resource
    else
      false
    end
  end

  def feedback_for?(resource)
    if resource.instance_of? Professional
      refused? and belongs_to? resource
    elsif resource.instance_of? User
      cancel? and feedback.present? and belongs_to? resource
    else
      false
    end
  end

  def can_cancel?(resource)
    if belongs_to?(resource) && accepted?
      Date.current <= deadline_cancel
    else
      pending?
    end
  end

  def days_remaning_for_cancel
    return (deadline_cancel - Date.current).to_i if Date.current.before? deadline_cancel

    0
  end

  private

  def block_new_proposals_if_not_open
    errors.add(:project_id, 'n??o pode receber novas propostas') if Project.find_by(id: project_id).present? &&
                                                                   !Project.find_by(id: project_id).open?
  end

  def duplicate_feeedback
    errors.add(:feedback, 'j?? existe') if feedback_changed? && !feedback_in_database.nil?
  end

  def presence_feedback_on_refused
    errors.add(:feedback, 'n??o deve ficar em branco') if refused? &&
                                                         feedback.blank?
  end

  def presence_feedback_on_cancel
    errors.add(:feedback, 'n??o pode ficar em branco') if cancel? &&
                                                         status_in_database.eql?('accepted') && feedback.blank?
  end

  def deadline_for_cancel_in_accepted
    self.deadline_cancel = 3.days.from_now if status_changed? && accepted?
  end
end
