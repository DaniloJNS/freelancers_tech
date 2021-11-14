# frozen_string_literal: true

# comments here
class StatusComponent < ViewComponent::Base
  def initialize(proposal:)
    super
    @proposal = proposal
    @color = set_color
  end

  private

  def set_color
    case @proposal.status
    when 'accepted' || 'open'
      'green'
    when 'refused' || 'closed'
      'red'
    when 'pending' || 'finished'
      'yellow'
    else
      'gray'
    end
  end
end
