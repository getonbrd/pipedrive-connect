# frozen_string_literal: true

module Pipedrive
  class Activity < Resource
    include Fields
    self.resources_url = "activities"

    def self.supports_v2_api?
      true
    end
  end
end
