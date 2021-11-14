# frozen_string_literal: true

# comments here
class ProposalComponent < ViewComponent::Base
  def initialize(proposal:, user: nil)
    super
    @proposal = proposal
    @user = user
  end
end
