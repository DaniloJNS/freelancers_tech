require 'rails_helper'

describe Proposal do
  context 'belongs_to' do
    let(:proposal) { subject }
    it 'professional must exists' do
      proposal.valid?
      expect(proposal.errors.full_messages_for(:professional)).to include(
        'Profissional é obrigatório(a)'
      )
    end

     it 'professional must exists' do
      proposal.valid?
      expect(proposal.errors.full_messages_for(:project)).to include(
        'Projeto é obrigatório(a)'
      )
    end
  end
  context 'validates' do
    context 'cant be blank' do
      let(:proposal) { subject }
      it 'justification' do
        proposal.valid?
        expect(proposal.errors.full_messages_for(:justification)).to include(
          'Justificativa não pode ficar em branco'
        ) 
      end
      it 'price_hour' do
        proposal.valid?
        expect(proposal.errors.full_messages_for(:price_hour)).to include(
          'Preço por hora não pode ficar em branco'
        ) 
      end
      it 'weekly_hour' do
        proposal.valid?
        expect(proposal.errors.full_messages_for(:weekly_hour)).to include(
          'Horas por semana não pode ficar em branco'
        ) 
      end
      it 'completion_deadline' do
        proposal.valid?
        expect(proposal.errors.full_messages_for(:completion_deadline)).to include(
          'Prazo de conclusão não pode ficar em branco'
        ) 
      end
     
    end
    context 'is numericality' do
      let(:proposal) { subject }
      it 'price_hour' do
        proposal.price_hour = 'sa'
        proposal.valid?
        expect(proposal.errors.full_messages_for(:price_hour)).to include(
          'Preço por hora não é um número'
        ) 
      end
      it 'weekly_hour' do
        proposal.weekly_hour = 'sa'
        proposal.valid?
        expect(proposal.errors.full_messages_for(:weekly_hour)).to include(
          'Horas por semana não é um número'
        ) 
      end
      it 'completion_deadline' do
        proposal.completion_deadline = 'sa'
        proposal.valid?
        expect(proposal.errors.full_messages_for(:completion_deadline)).to include(
          'Prazo de conclusão não é um número'
        ) 
      end
    end
    context 'greater than 0' do
      let(:proposal) { subject }
      it 'price_hour' do
        proposal.price_hour = -1
        proposal.valid?
        expect(proposal.errors.full_messages_for(:price_hour)).to include(
          'Preço por hora deve ser maior que 0'
        ) 
      end
      it 'weekly_hour' do
        proposal.weekly_hour = -1
        proposal.valid?
        expect(proposal.errors.full_messages_for(:weekly_hour)).to include(
          'Horas por semana deve ser maior que 0'
        ) 
      end
      it 'completion_deadline' do
        proposal.completion_deadline = -1
        proposal.valid?
        expect(proposal.errors.full_messages_for(:completion_deadline)).to include(
          'Prazo de conclusão deve ser maior que 0'
        ) 
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
      
    end
  end
end
