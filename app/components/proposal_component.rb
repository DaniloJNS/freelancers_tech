# frozen_string_literal: true

class ProposalComponent < ViewComponent::Base
  def initialize(proposal:, user: nil)
    @proposal = proposal
    @user = user
  end
end
