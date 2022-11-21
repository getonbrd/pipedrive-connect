# frozen_string_literal: true

module Pipedrive
  class User < Resource
    def self.search(term, search_by_email)
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
  end
end
