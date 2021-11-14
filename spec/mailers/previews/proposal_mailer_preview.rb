# frozen_string_literal: true

class ProposalMailerPreview < ActionMailer::Preview
  def notify_new_proposal
    @professional = FactoryBot.create(:professional)
    FactoryBot.create(:profile, professional: @professional)
    @proposal = FactoryBot.create(:proposal, professional: @professional)
    ProposalMailer.with(proposal: @proposal).notify_new_proposal
  end
end
