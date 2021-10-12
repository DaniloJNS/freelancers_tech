require 'rails_helper'

describe Profile do
  context 'belongs_to' do
    let(:profile) { subject }
    it 'professional must exists' do
      profile.valid?
      expect(profile.errors.full_messages_for(:professional)).to include('Pro'\
            'fissional é obrigatório(a)') 
  end
  end
  context 'validates' do
    let(:profile) { subject }
    context 'cant be blank' do
      it 'name' do
        profile.valid?
        expect(profile.errors.full_messages_for(:name)).to include('Nome não pode ficar em branco') 
      end
      it 'description' do
        profile.valid?
        expect(profile.errors.full_messages_for(:description)).to include('Descrição não pode ficar em branco') 
      end
      it 'birth_date' do
        profile.valid?
        expect(profile.errors.full_messages_for(:birth_date)).to include('Data de Nascimento não pode ficar em branco') 
      end
    end
    context 'birth_date' do
      let(:profile) { subject }
      it 'greater than 18 years' do
        profile.birth_date =  Date.current
        profile.valid?
        expect(profile.errors.full_messages_for(:age)).to include(
          'Idade deve ser maior que 18 anos') 
      end
      
    end
  end
end
