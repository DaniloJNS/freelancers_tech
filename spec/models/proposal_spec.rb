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
require 'rails_helper'
describe Proposal do
  include ActiveSupport::Testing::TimeHelpers
  context 'belongs_to' do
    let(:proposal) { subject }
    it 'professional must exists' do
      should belong_to(:professional)
    end
    it 'project must exists' do
      should belong_to(:project)
    end
  end
  context 'validates' do
    context 'cant be blank' do
      let(:proposal) { subject }
      it 'justification' do
        should validate_presence_of(:justification)
      end
      it 'price_hour' do
        should validate_presence_of(:price_hour)
      end
      it 'weekly_hour' do
        should validate_presence_of(:weekly_hour)
      end
      it 'completion_deadline' do
        should validate_presence_of(:completion_deadline)
      end
    end
    context 'is numericality' do
      let(:proposal) { subject }
      it 'price_hour' do
        should validate_numericality_of(:price_hour)
      end
      it 'weekly_hour' do
        should validate_numericality_of(:weekly_hour)
      end
      it 'completion_deadline' do
        should validate_numericality_of(:completion_deadline)
      end
    end
    context 'with project' do
      it 'status open can create proposal' do
        ecommerce = create(:project, status: 'open')

        proposal = create(:proposal, project: ecommerce)

        expect(proposal.errors.any?).to eq(false)
      end
      it 'status if not open can not create proposal' do
        ecommerce = create(:project, status: 'closed')

        proposal = build(:proposal, project: ecommerce)
        proposal.valid?

        expect(proposal.errors.full_messages_for(:project_id)).to include('Projeto não pode receber novas propostas')
      end
    end
    context 'greater than 0' do
      let(:proposal) { subject }
      it 'price_hour' do
        should validate_numericality_of(:price_hour).is_greater_than 0
      end
      it 'weekly_hour' do
        should validate_numericality_of(:weekly_hour).is_greater_than 0
      end
      it 'completion_deadline' do
        should validate_numericality_of(:completion_deadline).is_greater_than 0
      end
    end
    context 'enum' do
      it 'status' do
        should define_enum_for(:status).with_values(%i[pending accepted refused cancel])
      end
    end
    context 'refused' do
      it 'need have feedback' do
        proposal = create(:proposal, status: 'refused')
        proposal.valid?

        expect(proposal.errors.full_messages).to include(
          'Feedback não deve ficar em branco'
        )
      end
      it 'cant duplicate feeedback' do
        proposal = create(:proposal, status: 'refused',
                                     feedback: 'Optei por outro candidato')
        proposal.feedback = 'mudei o feedback'
        proposal.valid?

        expect(proposal.errors.full_messages).to include('Feedback já existe')
      end
      it 'has feedback for professional' do
        danilo = create(:user)
        maicon = create(:professional)
        ecommerce = create(:project, user: danilo)
        proposal = create(:proposal, project: ecommerce, professional: maicon,
                                     status: 'refused', feedback: 'optei por outro candidato')

        expect(proposal.feedback_for?(maicon)).to eq(true)
        expect(proposal.feedback_for?(danilo)).to eq(false)
      end
      it 'has not feedback for professional' do
        danilo = create(:user)
        maicon = create(:professional)
        create(:profile, professional: maicon)
        ecommerce = create(:project, user: danilo)
        proposal = create(:proposal, project: ecommerce, professional: maicon)

        expect(proposal.feedback_for?(maicon)).to eq(false)
        expect(proposal.feedback_for?(danilo)).to eq(false)
      end
    end
    context 'cancel' do
      it 'has feedback for user' do
        danilo = create(:user)
        maicon = create(:professional)
        create(:profile, professional: maicon)
        ecommerce = create(:project, user: danilo)
        proposal = create(:proposal, professional: maicon, project: ecommerce,
                                     status: 'cancel', feedback:
                         'Vou partipar de outro projeto')

        expect(proposal.feedback_for?(danilo)).to eq(true)
        expect(proposal.feedback_for?(maicon)).to eq(false)
      end
      it 'has not feedback for user' do
        danilo = create(:user)
        maicon = create(:professional)
        create(:profile, professional: maicon)
        ecommerce = create(:project, user: danilo)
        proposal = create(:proposal, project: ecommerce, professional: maicon)

        expect(proposal.feedback_for?(danilo)).to eq(false)
        expect(proposal.feedback_for?(maicon)).to eq(false)
      end
    end
    context 'accepted' do
      it 'can cancel proposal' do
        danilo = create(:user)
        maicon = create(:professional)
        create(:profile, professional: maicon)
        ecommerce = create(:project, user: danilo)
        proposal = create(:proposal, professional: maicon, project: ecommerce)
        proposal.update!(status: 'accepted')

        travel_to 2.days.from_now do
          expect(proposal.can_cancel?(maicon)).to eq(true)
        end
      end
      it 'can cancel in last day of deadline_submission' do
        danilo = create(:user)
        maicon = create(:professional)
        create(:profile, professional: maicon)
        ecommerce = create(:project, user: danilo)
        proposal = create(:proposal, professional: maicon, project: ecommerce)
        proposal.update!(status: 'accepted')

        travel_to 3.days.from_now do
          expect(proposal.can_cancel?(maicon)).to eq(true)
        end
      end
      it 'days remaming' do
        proposal = create(:proposal)
        proposal.update!(status: 'accepted')

        expect(proposal.days_remaning_for_cancel).to eq(3)
      end
      it 'days remaming on last day' do
        proposal = create(:proposal)
        proposal.update!(status: 'accepted')

        travel_to 3.days.from_now do
          expect(proposal.days_remaning_for_cancel).to eq(0)
        end
      end
      it 'cannot cancel proposal' do
        maicon = create(:professional)
        create(:profile, professional: maicon)
        proposal = create(:proposal, professional: maicon)
        proposal.update!(status: 'accepted')

        travel_to 4.days.from_now do
          expect(proposal.can_cancel?(maicon)).to eq(false)
        end
      end
      context 'pending' do
        it 'can cancel' do
          maicon = create(:professional)
          create(:profile, professional: maicon)
          proposal = create(:proposal, professional: maicon,
                                       status: 'pending')

          expect(proposal.can_cancel?(maicon)).to eq(true)
        end
      end
    end
  end
end
