# frozen_string_literal: true

class ProposalUnitComponent < ViewComponent::Base
  with_collection_parameter :proposal

  def initialize(proposal:)
    @proposal = proposal
    @color = setColor
  end

  private

  def setColor
    case @proposal.status
    when 'accepted'
      'green'
    when 'refused'
      'red'
    when 'pending'
      'yellow'
    else
      'gray'
    end
  end
end
