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
      # Set version specifically for fields operations
      def use_fields_version(version)
        @fields_version = version
      end

      # override the default version with the one provided
      def api_version
        return @version if @version

        # Fall back to original Request module logic if no version override
        super
      end

      # Fields-specific API version
      def fields_api_version
        @fields_version || api_version
      end

      def fields
        url = fields_url || "#{class_name.downcase}Fields"

        data = []
        start = 0
        request_more_fields = true

        while request_more_fields
          response = fields_request(:get, url, start: start)
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

      # Fields-specific request method that uses fields_api_version
      private def fields_request(method, url, params = {})
        # Temporarily override the api_version for this request
        original_version = @version
        @version = @fields_version if @fields_version

        begin
          request(method, url, params)
        ensure
          # Restore original version
          @version = original_version
        end
      end
    end

    def fields
      self.class.fields
    end
  end
end
