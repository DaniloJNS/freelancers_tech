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
end
