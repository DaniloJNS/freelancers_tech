# frozen_string_literal: true

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
  validate :start_after_conclusion, if: :start && :conclusion

  private

  def start_after_conclusion
    (errors.add(:start, 'não pode está numa data anterior à Data de Conclusão')) if start
      .after? conclusion
  end
end
