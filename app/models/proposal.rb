class Proposal < ApplicationRecord
  belongs_to :professional
  belongs_to :project

  validates :justification, :price_hour, :weekly_hour, :completion_deadline,
            presence: true
  validate :presence_feedback_on_refused, :duplicate_feeedback, on: :update
  validates :price_hour, :weekly_hour, :completion_deadline, :numericality => { :only => true,
  :greater_than => 0} 

  enum status: { pending: 0, accepted: 1, refused: 2 } 

  def belongs_to? resource
    resource.instance_of? User and
      project.user.eql? resource
  end
  def has_feedback_for? resource
    refused? and resource.instance_of? Professional and
      professional.eql? resource
  end

  private
  def duplicate_feeedback
    errors.add(:feedback, "já existe") if feedback_changed? and not 
      feedback_in_database.nil?
  end

  def presence_feedback_on_refused
    errors.add(:feedback, 'não deve ficar em branco') if refused? and 
      feedback.blank?
  end
end
