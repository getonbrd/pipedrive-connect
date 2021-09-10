# frozen_string_literal: true

module Pipedrive
  module APIOperations
    module Request
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def request(method, url, params = {})
          check_api_key!
          raise "Not supported method" \
            unless %i[get post put delete].include?(method)

          Util.debug "#{name} #{method.upcase} #{url}"

          response = api_client.send(method) do |req|
            req.url url
            req.params = params.merge(api_token: Pipedrive.api_key)
            req.body = params.to_json if %i[post put].include?(method)
          end
          Util.serialize_response(response)
        end

        def api_client
          @api_client = Faraday.new(
            url: BASE_URL,
            headers: { "Content-Type": "application/json" }
          ) do |faraday|
            faraday.response :logger if Pipedrive.debug_http
          end
        end

        protected def check_api_key!
          return if Pipedrive.api_key

          raise AuthenticationError, "No API key provided. " \
                                     "Set your API key using 'Pipedrive.api_key = <API-KEY>'"
        end
      end

      protected def request(method, url, params = {})
        self.class.request(method, url, params)
      end
    end
  end
end
