require 'rails_helper'

RSpec.describe ProposalMailer, type: :mailer do
  context 'new proposal' do
    it 'should notify user' do
      caio = create(:user)
      danilo = create(:professional)
      create(:profile, professional: danilo)

      project = create(:project, user: caio)

      proposal = create(:proposal, project: project, professional: danilo)

      mail = ProposalMailer.with(proposal: proposal).notify_new_proposal()
      
      expect(mail.to).to eq [caio.email]
      expect(mail.from).to eq ['nao-responder@freelancerstech.com']
      expect(mail.subject).to eq 'Nova proposta para seu projeto' 
      expect(mail.body).to include "Seu projeto #{project.title} recebeu uma nova "\
        "proposta de #{danilo.profile.name}"
    end
  end
end
