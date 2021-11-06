# frozen_string_literal: true

class ErrorMessagesComponent < ViewComponent::Base
  def initialize(model:)
    @model = model
  end

  def render?
    @model.errors.any?
  end
end
