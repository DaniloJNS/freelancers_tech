# frozen_string_literal: true

class ProposalsComponent < ViewComponent::Base
  def initialize(proposals:)
    @proposals = proposals
  end

end
