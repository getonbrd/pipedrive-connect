# frozen_string_literal: true

module Pipedrive
  module Merge
    def merge(with_id:)
      raise "with_id must be an integer" unless with_id&.is_a?(Integer)

      response = request(
        :put,
        "#{resource_url}/merge",
        merge_with_id: with_id
      )

      self.class.new(response[:data])
    end
  end
end
