# frozen_string_literal: true

module Pipedrive
  class Subscription < Resource
    # POST /subscriptions/recurring
    # Adds a recurring subscription
    def self.create_recurring(params)
      response = request(
        :post,
        "#{resource_url}/recurring",
        params
      )
      Subscription.new(response.dig(:data))
    end

    # PUT /subscriptions/recurring/:id
    # Updates a recurring subscription
    def update_recurring(params = {})
      response = request(
        :put,
        "#{self.class.resource_url}/recurring/#{id}",
        params
      )
      Subscription.new(response.dig(:data))
    end

    # PUT /subscriptions/recurring/:id/cancel
    # Cancels a recurring subscription
    def cancel_recurring(params = {})
      response = request(
        :put,
        "#{self.class.resource_url}/recurring/#{id}/cancel",
        params
      )
      Subscription.new(response.dig(:data))
    end

  end
end
