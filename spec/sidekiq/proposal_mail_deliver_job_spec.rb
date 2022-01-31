require 'rails_helper'

RSpec.describe ProposalMailDeliverJob, type: :job do
  context '#perform_async' do
    it 'deliver one email' do
      proposal = create(:proposal, completion_deadline: 3.days.from_now)

      proposal_mailer = stub_const('ProposalMailer',class_spy(ProposalMailer,
                        notify_new_proposal: double(deliver_now: nil)))

      ProposalMailDeliverJob.new.perform proposal.id

      expect(proposal_mailer).to have_received(:notify_new_proposal)
    end
    it 'build job' do
      proposal = create(:proposal, completion_deadline: 3.days.from_now)

      ProposalMailDeliverJob.perform_async proposal.id

      expect(ProposalMailDeliverJob.jobs.size).to eq 1
      expect(ProposalMailDeliverJob.sidekiq_options["retry"]).to eq false
      expect(ProposalMailDeliverJob.sidekiq_options["queue"]).to eq "default"
      expect(Sidekiq::Queues["default"].size).to eq 1 
      expect(Sidekiq::Queues["default"].first['args'][0]).to eq proposal.id
    end
  end
end
