# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                  :integer          not null, primary key
#  title               :string
#  description         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  deadline_submission :date
#  user_id             :integer          not null
#  remote              :boolean          default(FALSE)
#  max_price_per_hour  :decimal(, )
#  status              :integer          default("open")
#
require 'rails_helper'

describe Project do
  context 'belong_to' do
    let(:project) { subject }
    it 'user must exists' do
      should belong_to(:user)
    end
  end
  context 'has_many' do
    it 'proposals' do
      should have_many(:proposals)
    end
    it 'professionals through proposals' do
      should have_many(:professionals).through(:proposals)
    end
  end
  context 'validates' do
    let(:project) { subject }
    context 'cant be blank' do
      it 'title' do
        should validate_presence_of(:title).on(:create)
      end
      it 'description' do
        should validate_presence_of(:description).on(:create)
      end
      it 'max_price_per_hour' do
        should validate_presence_of(:max_price_per_hour).on(:create)
      end
      it 'deadline_submission' do
        should validate_presence_of(:deadline_submission).on(:create)
      end
    end
    context 'max_price_per_hour' do
      it 'must be numericality' do
        should validate_numericality_of(:max_price_per_hour)
      end
      it 'must be greater_than 0' do
        should validate_numericality_of(:max_price_per_hour).is_greater_than 0
      end
    end
    context 'not must be in the past' do
      let(:project) { subject }
      it 'deadline_submission' do
        project.deadline_submission = 1.day.ago.to_date
        project.valid?
        expect(project.errors.full_messages_for(:deadline_submission)).to include(
          'Prazo para submissão não pode está no passado'
        )
      end
    end
    context 'enum' do
      it 'status' do
        should define_enum_for(:status).with_values(%i[open closed finished])
      end
    end
    context 'methods' do
      let(:project) { subject }
      context 'days_remaining' do
        it 'deadline_submission later date current' do
          project.deadline_submission = 1.day.from_now
          expect(project.days_remaining).to eq(1)
        end
        it 'deadline_submission equal to date current' do
          project.deadline_submission = Date.current
          expect(project.days_remaining).to eq(0)
        end
        it 'deadline_submission before date current' do
          project.deadline_submission = 1.day.ago
          expect(project.days_remaining).to eq(0)
        end
      end
      context 'belongs_to' do
        context 'professional' do
          it 'has proposal' do
            danilo = create(:professional)
            create(:profile, professional: danilo)

            project = create(:project)
            proposal = create(:proposal, project: project, professional: danilo)

            expect(project.belongs_to?(danilo)).to eq(true)
          end
        end
        it 'has not proposal' do
          danilo = create(:professional)
          create(:profile, professional: danilo)

          project = create(:project)

          expect(project.belongs_to?(danilo)).to eq(false)
        end
      end
      context 'user' do
        it 'real' do
          danilo = create(:user)

          project = create(:project, user: danilo)

          expect(project.belongs_to?(danilo)).to eq(true)
        end
        it 'unreal' do
          jackson = create(:user)
          danilo = create(:user)

          project = create(:project, user: danilo)

          expect(project.belongs_to?(jackson)).to eq(false)
        end
      end
      context 'average_offer' do
        it 'with many proposals' do
          project = create(:project)
          proposal = create_list(:proposal, 10, project: project, price_hour: 100)

          expect(project.average_offer).to eq(100)
        end
        it 'without proposals' do
          project = create(:project)

          expect(project.average_offer).to eq(0)
        end
      end
    end
  end
end
