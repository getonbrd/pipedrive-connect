# frozen_string_literal: true

module Pipedrive
  class Product < Resource
    include Fields

    def self.supports_v2_api?
      false
    end
  end
end
