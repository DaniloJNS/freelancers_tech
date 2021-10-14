class Proposal < ApplicationRecord
  belongs_to :professional
  belongs_to :project
  validates :justification, :price_hour, :weekly_hour, :completion_deadline, 
            presence: true
  validates :price_hour, :weekly_hour, :numericality => { :only => true,
  :greater_than => 0} 
end
