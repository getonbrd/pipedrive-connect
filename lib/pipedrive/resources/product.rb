# frozen_string_literal: true

module Pipedrive
  class Product < Resource
    include Fields

    # fields are only available in v1
    # https://developers.pipedrive.com/docs/api/v1/ProductFields#getProductFields
    use_fields_version :v1

    def self.supports_v2_api?
      true
    end
  end
end
