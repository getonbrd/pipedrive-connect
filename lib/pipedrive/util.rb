# frozen_string_literal: true

module Pipedrive
  module Util
    def self.serialize_response(response, symbolize_names: true)
      rjson = JSON.parse(response.body, symbolize_names: symbolize_names)
      return rjson if response.success?

      Pipedrive.raise_error(response.status, rjson)
    end

    def self.debug(message)
      Pipedrive.logger&.debug(message) if Pipedrive.debug
    end
  end
end
