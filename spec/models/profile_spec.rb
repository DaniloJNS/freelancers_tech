# == Schema Information
#
# Table name: profiles
#
#  id              :integer          not null, primary key
#  name            :string
#  social_name     :string
#  description     :string
#  birth_date      :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  professional_id :integer          not null
#  age             :integer
#
require 'rails_helper'

describe Profile do
  context 'belongs_to' do
    let(:profile) { subject }
    it 'professional must exists' do
      should belong_to(:professional)
    end
  end
  context 'has_many' do
    it 'formations' do
      should have_many(:formations)
    end
    it 'experiences' do
      should have_many(:experiences)
    end
  end
  context 'validates' do
    let(:profile) { subject }
    context 'cant be blank' do
      it 'name' do
        should validate_presence_of(:name)
      end
      it 'description' do
        should validate_presence_of(:description)
      end
      it 'birth_date' do
        should validate_presence_of(:birth_date)
      end
    end
    context 'birth_date' do
      let(:profile) { subject }
      it 'is not greater than 18 years' do
        profile.birth_date =  Date.current
        profile.valid?
        expect(profile.errors.full_messages_for(:age)).to include(
          'Idade deve ser maior que 18 anos'
        )
      end
      it 'is greater than 18 years' do
        profile.birth_date = 18.years.ago
        profile.valid?
        expect(profile.errors.full_messages_for(:age)).to eq([])
      end
    end
  end
end
