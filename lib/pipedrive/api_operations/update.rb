# frozen_string_literal: true

module Pipedrive
  module APIOperations
    module Update
      def update(params)
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
