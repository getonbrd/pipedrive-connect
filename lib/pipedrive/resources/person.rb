# frozen_string_literal: true

module Pipedrive
  class Person < Resource
    include Fields
    include Merge

    has_many :deals, class_name: "Deal"
    has_many :activities, class_name: "Activity"

    # fields are only available in v1
    # https://developers.pipedrive.com/docs/api/v1/PersonFields#getPersonFields
    use_fields_version :v1

    def self.supports_v2_api?
      true
    end
  end
end
