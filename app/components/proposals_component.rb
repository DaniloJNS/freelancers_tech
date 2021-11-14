# frozen_string_literal: true

# comments here
class ProposalsComponent < ViewComponent::Base
  def initialize(proposals:)
    super
    @proposals = proposals
  end
end
