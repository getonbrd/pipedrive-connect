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
            req.params = { api_token: Pipedrive.api_key }
            if %i[post put].include?(method)
              req.body = params.to_json
            else
              req.params.merge!(params)
            end
          end

          raise "No item returned" if response.body.empty?
          Util.serialize_response(response)
        end

        def api_client
          @api_client = Faraday.new(
            url: BASE_URL,
            headers: { "Content-Type": "application/json" }
          ) do |faraday|
            if Pipedrive.debug_http
              faraday.response :logger, Pipedrive.logger,
                               bodies: Pipedrive.debug_http_body
            end
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
