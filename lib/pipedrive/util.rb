# frozen_string_literal: true

module Pipedrive
  module Util
    def self.serialize_response(response, symbolize_names: true)
      if Pipedrive.treat_no_content_as_not_found && response.status == 204
        Pipedrive.raise_error(404, error: "HTTP 204 status code received. No content")
      end

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
