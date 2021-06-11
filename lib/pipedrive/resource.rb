# frozen_string_literal: true

module Pipedrive
  class Resource
    include Pipedrive::APIOperations::Request
    extend  Pipedrive::APIOperations::Create
    include Pipedrive::APIOperations::Update
    include Pipedrive::APIOperations::Delete

    class << self
      attr_accessor :resources_url
    end

    def self.class_name
      name.split("::")[-1]
    end

    def self.resource_url
      if self == Resource
        raise NotImplementedError,
              "Pipedrive::Resource is an abstract class. You should perform actions " \
              "on its subclasses (Organization, Person, Deal, etc)"
      end
      resources_url || "#{class_name.downcase}s"
    end

    def self.fields_dicc
      @fields_dicc ||= fields[0] if respond_to? :fields
    end

    def self.inverted_fields_dicc
      @inverted_fields_dicc ||= fields_dicc&.invert
    end

    def self.search_for_fields(values)
      return values unless values.is_a?(Hash) && fields_dicc.any?

      values.reduce({}) do |new_hash, (k, v)|
        if inverted_fields_dicc[k]
          new_hash.merge(inverted_fields_dicc[k] => v)
        else
          new_hash.merge(k => v)
        end
      end
    end

    def self.retrieve(id)
      response = request(:get, "#{resource_url}/#{id}")
      new(response.dig(:data))
    end

    def self.all(params = {})
      response = request(:get, resource_url, params)
      response.dig(:data)&.map { |d| new(d) }
    end

    def self.search(term, params = {})
      response = request(
        :get,
        "#{resource_url}/search",
        { term: term }.merge(params)
      )
      response.dig(:data, :items).map { |d| new(d.dig(:item)) }
    end

    def self.has_many(resource_name, class_name:)
      unless resource_name && class_name
        raise "You must specify the resource name and its class name " \
              "For example has_many :deals, class_name: 'Deal'"
      end
      class_name_lower_case = class_name.downcase
      # always include all the data of the resource
      options = { "include_#{class_name_lower_case}_data": 1 }
      # add namespace to class_name
      class_name = "::Pipedrive::#{class_name}" unless class_name.include?("Pipedrive")
      define_method(resource_name) do |params = {}|
        response = request(:get,
                           "#{resource_url}/#{resource_name}",
                           params.merge(options))
        response.dig(:data)&.map do |data|
          class_name_as_sym = class_name_lower_case.to_sym
          if data.key?(class_name_as_sym)
            data = data.merge(data.delete(class_name_as_sym))
          end
          Object.const_get(class_name).new(data)
        end
      end
    end

    def initialize(data = {})
      @data = @unsaved_data = {}
      initialize_from_data(data)
    end

    def resource_url
      "#{self.class.resource_url}/#{id}"
    end

    def search_for_fields(values)
      self.class.search_for_fields(values)
    end

    def update_attributes(new_attrs)
      new_attrs.delete("id")
      @data.merge!(new_attrs)
    end

    def refresh
      response = request(:get, resource_url)
      initialize_from_data(response.dig(:data))
    end

    def initialize_from_data(data)
      klass = self.class
      # init data
      @data = data
      # generate the methods
      data.each_key do |k|
        # it could be a custom field diccionary
        m, is_custom_field = klass.fields_dicc&.dig(k) &&
                             [klass.fields_dicc&.dig(k), true] ||
                             [k, false]

        if m == :method
          # Object#method is a built-in Ruby method that accepts a symbol
          # and returns the corresponding Method object. Because the API may
          # also use `method` as a field name, we check the arity of *args
          # to decide whether to act as a getter or call the parent method.
          klass.define_method(m) do |*args|
            args.empty? ? fetch_value(m, is_custom_field) : super(*args)
          end
        else
          klass.define_method(m) { fetch_value(m, is_custom_field) }
        end

        klass.define_method(:"#{m}=") do |value|
          @data[m] = @unsaved_data[m] = value
        end

        next unless [FalseClass, TrueClass].include?(
          fetch_value(m, is_custom_field).class
        )

        klass.define_method(:"#{m}?") do
          fetch_value(m, is_custom_field)
        end
      end
      self
    end

    protected def fetch_value(key, is_custom_field)
      @data[is_custom_field ? self.class.inverted_fields_dicc.dig(key) : key]
    end
  end
end
