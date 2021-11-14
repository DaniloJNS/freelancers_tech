# frozen_string_literal: true

# comments here
class ProposalUnitComponent < ViewComponent::Base
  with_collection_parameter :proposal

  def initialize(proposal:)
    super
    @proposal = proposal
    @color = set_color
  end

  private

  def set_color
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
