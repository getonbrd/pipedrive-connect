# frozen_string_literal: true

module Pipedrive
  module APIOperations
    module Create
      def create(params)
        response = request(
          :post,
          resource_url,
          search_for_fields(params)
        )
        new(response.dig(:data))
      end
    end
  end
end
