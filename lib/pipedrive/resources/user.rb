# frozen_string_literal: true

module Pipedrive
  class User < Resource
    # GET /v1/users/find/
    # Find users by their name or email
    def self.find(term, search_by_email)
      params = { term: term }
      params = params.merge({ search_by_email: 1 }) if search_by_email
      response = request(
        :get,
        "#{resource_url}/find",
        params
      )
      items = response[:data]

      return [] if items.nil?

      items.map { |d| new(d) }
    end

    def self.supports_v2_api?
      true
    end
  end
end
