# frozen_string_literal: true

require 'json'
module ApiMacro
  def parsed_body
    @parsed_body ||= JSON.parse(response.body, symbolize_names: true)
  end
end
