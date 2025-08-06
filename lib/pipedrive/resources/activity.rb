# frozen_string_literal: true

module Pipedrive
  class Activity < Resource
    include Fields

    # fields are only available in v1
    # https://developers.pipedrive.com/docs/api/v1/ActivityFields#getActivityFields
    use_fields_version :v1

    self.resources_url = "activities"

    def self.supports_v2_api?
      true
    end
  end
end
