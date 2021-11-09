# frozen_string_literal: true

# == Schema Information
#
# Table name: professionals
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require 'rails_helper'

describe Professional do
  context 'has many' do
    let(:professional) { subject }
    it 'proposals' do
      should have_many(:proposals)
    end
    it 'project through proposals' do
      should have_many(:projects).through(:proposals)
    end
  end
  context 'has one' do
    it 'profile' do
      should have_one(:profile).dependent(:destroy)
    end
  end
  context 'methods' do
    context 'proposal_id_a' do
      it 'have project' do
        danilo = create(:professional)
        create(:profile, professional: danilo)

        project = create(:project)
        proposal = create(:proposal, project: project, professional: danilo)

        expect(danilo.proposal_id_of_a(project)).to eq(proposal)
      end
      it 'have not project' do
        danilo = create(:professional)
        create(:profile, professional: danilo)

        project = create(:project)

        expect(danilo.proposal_id_of_a(project)).to eq(nil)
      end
    end
    context 'profile' do
      it 'must be present' do
       danilo = create(:professional)
       create(:profile, professional: danilo) 

       expect(danilo.profile?).to be true
      end
      it 'not be present' do
        danilo = create(:professional)

        expect(danilo.profile?).to be false
      end
    end
  end
end
