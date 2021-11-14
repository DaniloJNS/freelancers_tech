# frozen_string_literal: true

# comments here
class ErrorMessagesComponent < ViewComponent::Base
  def initialize(model:)
    super
    @model = model
  end

  def render?
    @model.errors.any?
  end
end
