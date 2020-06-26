# frozen_string_literal: true

module Pipedrive
  class Activity < Resource
    include Fields
    self.resources_url = "activities"
  end
end
