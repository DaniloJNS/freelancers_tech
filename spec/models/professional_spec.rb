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
        danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
        maicon = Professional.create!(email: 'maicon_comp@mail.com', password: '1234567')
        Profile.create!(name: 'maicon', description: 'Dev back-end laravel and django',
                        birth_date: '11/4/1990', professional: maicon)

        project = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                                                                        'atividades escolares', deadline_submission: 5.days.from_now, remote: true,
                                  max_price_per_hour: 150, user: danilo)
        proposal = Proposal.create!(justification: 'tenho habilidades para esse projeto', price_hour: 100, weekly_hour: 30,
                                    completion_deadline: 30, professional: maicon, project: project)
        expect(maicon.proposal_id_of_a(project)).to eq(proposal)
      end
      it 'have not project' do
        danilo = User.create!(email: 'danilo@rmotors.com.br', password: '1234567')
        maicon = Professional.create!(email: 'maicon_comp@mail.com', password: '1234567')
        Profile.create!(name: 'maicon', description: 'Dev back-end laravel and django',
                        birth_date: '11/4/1990', professional: maicon)

        project = Project.create!(title: 'Portal Escolar', description: 'Um portal para gerenciamento de '\
                                                                        'atividades escolares', deadline_submission: 5.days.from_now, remote: true,
                                  max_price_per_hour: 150, user: danilo)
        expect(maicon.proposal_id_of_a(project)).to eq(nil)
      end
    end
  end
end
