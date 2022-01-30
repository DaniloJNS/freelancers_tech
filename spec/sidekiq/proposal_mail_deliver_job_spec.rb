require 'rails_helper'

RSpec.describe ProposalMailDeliverJob, type: :job do
  context '#perform_async' do
    it 'Submit one email' do
      proposal = create(:proposal, completion_deadline: 3.days.from_now)

        ProposalMailDeliverJob.perform_async proposal.id

        expect(ProposalMailDeliverJob.jobs.size).to eq 1
        expect(ProposalMailDeliverJob.sidekiq_options["retry"]).to eq false
        expect(ProposalMailDeliverJob.sidekiq_options["queue"]).to eq "default"
    end
  end
end
