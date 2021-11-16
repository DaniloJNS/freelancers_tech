# frozen_string_literal: true

# comments here
class ProfileCardComponent < ViewComponent::Base
  def initialize(profile:)
    super
    @profile = profile
  end
end
