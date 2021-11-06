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
      context 'conclusion' do
        let(:formation) { subject }
        it 'can not be in the the future if status conclusion' do
          formation.status = true
          formation.conclusion = 1.day.from_now
          formation.valid?

          expect(formation.errors.full_messages_for(:conclusion)).to include('Data '\
                                                                             'de Conclusão não pode está no futuro')
        end
        it 'can not be in the past if status in progress' do
          formation.status = false
          formation.conclusion = 1.day.ago
          formation.valid?

          expect(formation.errors.full_messages_for(:conclusion)).to include('Data '\
                                                                             'de Conclusão não pode está no passado')
        end
      end
      context 'start' do
        let(:formation) { subject }
        it 'can not be before conclusion' do
          formation.status = true
          formation.start  = 3.day.from_now
          formation.conclusion = 1.day.from_now
          formation.valid?

          expect(formation.errors.full_messages_for(:start)).to include('Data '\
                                                                        'de Início não pode está numa data anterior à Data de Conclusão')
        end
      end
    end
  end
end
