# frozen_string_literal: true

# == Schema Information
#
# Table name: experiences
#
#  id          :integer          not null, primary key
#  company     :string           not null
#  office      :string           not null
#  description :string           not null
#  start_date  :date             not null
#  end_date    :date
#  current_job :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Experience < ApplicationRecord
  belongs_to :profile

  validates :company, :office, :description, :start_date, presence: true
  validates :end_date, presence: true, if: :current_job
  validate :end_date_before_start_date, if: :current_job

  private

  def end_date_before_start_date
    errors.add(:end_date, 'não deve ser antes da Data de Início') if end_date
                                                                     .before? start_date
  end
end
