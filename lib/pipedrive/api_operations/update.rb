# frozen_string_literal: true

module Pipedrive
  module APIOperations
    module Update
      def update(params)
        # Pipedrive answers an empty update with a 400: there is nothing to send.
        return @data if params.nil? || params.empty?

        response = request(
          update_method || :put,
          resource_url,
          search_for_fields(params)
        )
        update_attributes(response.dig(:data))
      end
    end
  end
end
