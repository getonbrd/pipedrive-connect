# frozen_string_literal: true

module Pipedrive
  class Organization < Resource
    include Fields
    include Merge

    has_many :activities, class_name: "Activity"
    has_many :deals, class_name: "Deal"
    has_many :persons, class_name: "Person"

    # fields are only available in v1
    # https://developers.pipedrive.com/docs/api/v1/OrganizationFields#getOrganizationFields
    use_fields_version :v1

    def self.supports_v2_api?
      true
    end
  end
end
