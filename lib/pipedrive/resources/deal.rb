# frozen_string_literal: true

module Pipedrive
  class Deal < Resource
    include Fields
    include Merge

    has_many :products, class_name: "Product"
    has_many :participants, class_name: "Participant"

    # fields are only available in v1
    # https://developers.pipedrive.com/docs/api/v1/DealFields#getDealFields
    use_fields_version :v1

    def self.supports_v2_api?
      true
    end
  end
end
