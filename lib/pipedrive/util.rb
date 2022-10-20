# frozen_string_literal: true

module Pipedrive
  module Util
    def self.serialize_response(response, symbolize_names: true)
      if response.status == 204
        return {} unless Pipedrive.treat_no_content_as_not_found

        Pipedrive.raise_error(404, error: "HTTP 204 status code received. No content")
      end

      json_body = JSON.parse(response.body, symbolize_names: symbolize_names)

      if response.success?
        json_body
      else
        Pipedrive.raise_error(response.status, json_body)
      end
    end

    def self.debug(message)
      Pipedrive.logger&.debug(message) if Pipedrive.debug
    end
  end
end
