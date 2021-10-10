require 'rails_helper'

describe Project do
  context 'belong_to' do
    let(:project) { subject }
    it 'user must exists' do
      project.valid?
      expect(project.errors.full_messages_for(:user)).to include('Usuário é obrigatório(a)') 
    end
  end
  context 'validates' do
    let(:project) { subject }
    context 'cant not be blank' do
      it 'title' do
        project.valid?
        expect(project.errors.full_messages_for(:title)).to include('Título não pode ficar em branco') 
      end
      it 'description' do
        project.valid?
        expect(project.errors.full_messages_for(:description)).to include('Descrição não pode ficar em branco') 
      end
      it 'max_price_per_hour' do
        project.valid?
        expect(project.errors.full_messages_for(:max_price_per_hour)).to include('Preço máximo por hora não pode ficar em branco') 
      end
      it 'deadline_submission' do
        project.valid?
        expect(project.errors.full_messages_for(:deadline_submission)).to include('Prazo para submissão não pode ficar em branco') 
      end
    end
    context 'must be greater_than 0' do
      it 'max_price_per_hour' do
        project.max_price_per_hour = 0
        project.valid?
        expect(project.errors.full_messages_for(:max_price_per_hour)).to include('Preço máximo por hora deve ser maior que 0') 
      end
    end
  end
end
