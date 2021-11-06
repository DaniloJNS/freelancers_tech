# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  def initialize(text:, path: '/', method: :get, local: false, color: 'blue', p: 1)
    @text = text
    @path = path
    @method = method
    @local = local
    @color = color
    @p = p
  end
end
