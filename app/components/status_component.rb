# frozen_string_literal: true

class StatusComponent < ViewComponent::Base
  def initialize(proposal:)
    @proposal = proposal
    @color = setColor
  end

  private

  def setColor
    case @proposal.status
    when 'accepted'
      'green'
    when 'open'
      'green'
    when 'refused'
      'red'
    when 'closed'
      'red'
    when 'pending'
      'yellow'
    when 'finished'
      'yellow'
    else
      'gray'
    end
  end
end
