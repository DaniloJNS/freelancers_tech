# == Schema Information
#
# Table name: formations
#
#  id         :integer          not null, primary key
#  university :string
#  conclusion :date
#  start      :date
#  status     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  profile_id :integer          not null
#
class Formation < ApplicationRecord
  belongs_to :profile
  validates :university, :conclusion, :start, presence: true
  validate :conclusion_valid, :start_valid

  private
  def conclusion_valid
    errors.add :conclusion, "não pode está no futuro"  if not conclusion.nil? and Date.current.before? conclusion and
      status
    errors.add :conclusion, "não pode está no passado" if not conclusion.nil? and not Date.current.before? conclusion and
      not status
  end
  def start_valid
    errors.add :start, "não pode está numa data anterior à Data de Conclusão" if not conclusion.nil? and
      not start.nil? and conclusion.before? start     
  end
end
