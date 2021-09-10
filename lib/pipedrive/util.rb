# frozen_string_literal: true

module Pipedrive
  module Util
    def self.serialize_response(response, symbolize_names: true)
      rjson = JSON.parse(response.body, symbolize_names: symbolize_names)
      return rjson if response.success?

      raise_error(response.status, rjson)
    end

    def self.raise_error(status, response)
      case status
      when 404
        raise NotFoundError.new(response.dig(:error), status)
      else
        raise UnkownAPIError.new(response.dig(:error), status)
      end
    end

    def self.debug(message)
      Pipedrive.logger&.debug(message) if Pipedrive.debug
    end
  end
end
