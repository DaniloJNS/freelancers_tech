class ProposalMailDeliverJob
  include Sidekiq::Job
  sidekiq_options retry: false

  def perform(proposal_id)
    @proposal = Proposal.find proposal_id
    ProposalMailer.with(proposal: @proposal).notify_new_proposal.deliver_now
  end
end
