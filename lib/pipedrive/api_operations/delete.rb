# frozen_string_literal: true

module Pipedrive
  module APIOperations
    module Delete
      def delete
        request(:delete, resource_url)
      end
    end
  end
end
