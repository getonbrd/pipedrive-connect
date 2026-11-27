# frozen_string_literal: true

module Pipedrive
  module Util
    def self.serialize_response(response, symbolize_names: true)
      if response.status == 204
        return {} unless Pipedrive.treat_no_content_as_not_found

        Pipedrive.raise_error(404, error: "HTTP 204 status code received. No content")
      end

      json_body = parse_body(response, symbolize_names: symbolize_names)

      if response.success?
        json_body
      else
        Pipedrive.raise_error(response.status, json_body)
      end
    end

    # A non-JSON body (an HTML error page from a proxy or an outage) raises the
    # error class for its status, or InvalidResponseError, instead of a bare
    # JSON::ParserError, so callers can rescue and retry by status.
    def self.parse_body(response, symbolize_names: true)
      JSON.parse(response.body, symbolize_names: symbolize_names)
    rescue JSON::ParserError
      message = "Pipedrive answered HTTP #{response.status} with a non-JSON body"
      error_class = response.success? ? nil : ERROR_CLASS_MAP[response.status.to_s]
      raise((error_class || InvalidResponseError).new(message, response.status))
    end

    def self.debug(message)
      Pipedrive.logger&.debug(message) if Pipedrive.debug
    end
  end
end
