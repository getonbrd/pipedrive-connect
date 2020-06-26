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
        data = request(:get, url).dig(:data)
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
