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
require 'rails_helper'

describe Formation do
  context 'belong_to' do
    it 'profile must exists' do
      should belong_to(:profile)
    end
  end
  context 'validates' do
    context 'cant be blank' do
      it 'university' do
        should validate_presence_of(:university)
      end
      it 'conclusion' do
        should validate_presence_of(:conclusion)
      end
      it 'start' do
        should validate_presence_of(:start)
      end
    end
    context 'dates' do
      context 'start' do
        let(:formation) { subject }
        it 'can not be before conclusion' do
          formation.start = 3.days.from_now
          formation.conclusion = 1.day.from_now
          formation.valid?

          expect(formation.errors.full_messages_for(:start)).to include(
            'Data de Início não pode está numa data anterior à Data de Conclusão'
          )
        end
        it 'can be before coclusion' do
          formation.start = 1.day.from_now
          formation.conclusion = 5.days.from_now
          formation.valid?

          expect(formation.errors.full_messages_for(:start)).to eq []
        end
      end
    end
  end
end
