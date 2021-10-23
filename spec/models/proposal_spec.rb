require 'rails_helper'

describe Proposal do
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
        should define_enum_for(:status).with_values([:pending, :accepted, :refused])
      end
    end
    context 'refused' do
      it 'need have feedback' do
       
        danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
        maicon = Professional.create!(email: 'maicon_comp@mail.com', password: '1234567')
                 Profile.create!(name: 'maicon', description: 'Dev back-end laravel and django',
                                 birth_date: '11/4/1990', professional: maicon)
        ecommerce = Project.create!(title: 'E-commerce de carros', description: 'uma plataforma para venda, '\
                                    'troca e compra de carros', deadline_submission: 1.week.from_now, remote: true,
                                    max_price_per_hour: 250, user: danilo)
        proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                           completion_deadline: 50, professional: maicon, project: ecommerce,
                                           status: 'refused')
        proposal.valid?
        expect(proposal.errors.full_messages).to include(
          'Feedback não deve ficar em branco'
        ) 
      end
      it 'cant duplicate feeedback' do
        danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
        maicon = Professional.create!(email: 'maicon_comp@mail.com', password: '1234567')
                 Profile.create!(name: 'maicon', description: 'Dev back-end laravel and django',
                                 birth_date: '11/4/1990', professional: maicon)
        ecommerce = Project.create!(title: 'E-commerce de carros', description: 'uma plataforma para venda, '\
                                    'troca e compra de carros', deadline_submission: 1.week.from_now, remote: true,
                                    max_price_per_hour: 250, user: danilo)
        proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                    completion_deadline: 50, professional: maicon, project: ecommerce,
                                    status: 'refused', feedback: 'Optei por outro candidato')
        proposal.feedback = "mudei o feedback"
        proposal.valid?
        expect(proposal.errors.full_messages).to include('Feedback já existe') 
      end
      it 'has feedback for professional' do
        danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
        maicon = Professional.create!(email: 'maicon_comp@mail.com', password: '1234567')
                 Profile.create!(name: 'maicon', description: 'Dev back-end laravel and django',
                                 birth_date: '11/4/1990', professional: maicon)
        ecommerce = Project.create!(title: 'E-commerce de carros', description: 'uma plataforma para venda, '\
                                    'troca e compra de carros', deadline_submission: 1.week.from_now, remote: true,
                                    max_price_per_hour: 250, user: danilo)
        proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                    completion_deadline: 50, professional: maicon, project: ecommerce,
                                    status: 'refused', feedback: 'Optei por outro candidato')
        
        expect(proposal.has_feedback_for? maicon).to eq(true) 
      end
      it 'has not feedback for professional' do
        danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
        maicon = Professional.create!(email: 'maicon_comp@mail.com', password: '1234567')
                 Profile.create!(name: 'maicon', description: 'Dev back-end laravel and django',
                                 birth_date: '11/4/1990', professional: maicon)
        ecommerce = Project.create!(title: 'E-commerce de carros', description: 'uma plataforma para venda, '\
                                    'troca e compra de carros', deadline_submission: 1.week.from_now, remote: true,
                                    max_price_per_hour: 250, user: danilo)
        proposal = Proposal.create!(justification: 'Sou bom em java', price_hour: 100, weekly_hour: 20,
                                    completion_deadline: 50, professional: maicon, project: ecommerce)

        expect(proposal.has_feedback_for? maicon).to eq(false) 
      end
    end
  end
end
