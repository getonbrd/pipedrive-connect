# frozen_string_literal: true

module Pipedrive
  module Util
    def self.serialize_response(response, symbolize_names: true)
      if response.success?
        return {} if response.status == 204

        JSON.parse(response.body, symbolize_names: symbolize_names)
      else
        error_body = JSON.parse(response.body, symbolize_names: symbolize_names)
        Pipedrive.raise_error(response.status, error_body)
      end
    end

    def self.debug(message)
      Pipedrive.logger&.debug(message) if Pipedrive.debug
    end
  end
end
