# frozen_string_literal: true

module Pipedrive
  module Fields
    def self.included(base)
      class << base
        attr_accessor :fields_url
      end
      base.extend(ClassMethods)
    end

    module ClassMethods
      def fields
        url = fields_url || "#{class_name.downcase}Fields"

        data = []
        start = 0
        request_more_fields = true

        while request_more_fields
          response = request(:get, url, start: start)
          data.concat(response.dig(:data))
          # Check wether there are more fields to bring
          metadata = response.dig(:additional_data, :pagination)
          request_more_fields = metadata&.fetch(:more_items_in_collection, false)
          start = metadata[:next_start] if request_more_fields
        end
        # return a hash prefilled with
        # the fields hash and name parameterized
        # and the original array of fields (schema)
        dicc = data.reduce({}) do |fields_dicc, field|
          # snakify the name
          snake_name = field.dig(:name).gsub(/\w+/).reduce([]) do |words, c|
            words << c.downcase
          end.join("_")

          fields_dicc.merge(
            field.dig(:key).to_sym => snake_name.to_sym
          )
        end
        [dicc, data]
      end
    end

    def fields
      self.class.fields
    end
  end
end
