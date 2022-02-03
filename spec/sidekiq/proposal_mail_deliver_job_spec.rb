require 'rails_helper'

RSpec.describe ProposalMailDeliverJob, type: :job do
  context '#perform_async' do
    let(:proposal) { create(:proposal, completion_deadline: 3.days.from_now) }
    it 'deliver one email' do
      proposal_mailer = stub_const('ProposalMailer', class_spy(ProposalMailer, notify_new_proposal:
                                                               double(deliver_now: nil)))

      ProposalMailDeliverJob.new.perform proposal.id

      expect(proposal_mailer).to have_received(:notify_new_proposal)
    end

    it 'goes into the jobs array for testing environment' do
      expect do
        ProposalMailDeliverJob.perform_async proposal.id
      end.to change(ProposalMailDeliverJob.jobs, :size).by(1)
    end

    it 'build job' do
      ProposalMailDeliverJob.perform_async proposal.id

      expect(ProposalMailDeliverJob.jobs.size).to eq 1
      expect(ProposalMailDeliverJob.queue).to eq 'mailers'
      expect(ProposalMailDeliverJob.sidekiq_options['retry']).to eq 10
      expect(ProposalMailDeliverJob.sidekiq_options['retry_queue']).to eq 'low'
      expect(Sidekiq::Queues['mailers'].size).to eq 1
      expect(Sidekiq::Queues['mailers'].first['args'][0]).to eq proposal.id
    end
  end
end
