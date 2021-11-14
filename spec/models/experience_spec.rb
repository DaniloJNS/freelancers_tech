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
require 'rails_helper'

describe Experience do
  context 'belongs_to' do
    it 'profile must exists' do
      should belong_to(:profile)
    end
  end
  context 'validate' do
    context 'cant be blank' do
      it 'company' do
        should validate_presence_of(:company)
      end
      it 'office' do
        should validate_presence_of(:office)
      end
      it 'start_date' do
        should validate_presence_of(:start_date)
      end
      it 'description' do
        should validate_presence_of(:description)
      end
    end
    context 'dates' do
      let(:experience) { subject }
      it 'end_date can not before start_date' do
        experience.start_date = Date.current
        experience.end_date = 1.day.ago
        experience.current_job = true
        experience.valid?

        expect(experience.errors.full_messages_for(:end_date)).to include(
          'Data de Termínio não deve ser antes da Data de Início'
        )
      end
    end
  end
end
