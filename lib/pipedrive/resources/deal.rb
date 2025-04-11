# frozen_string_literal: true

module Pipedrive
  class Deal < Resource
    include Fields
    include Merge

    has_many :products, class_name: "Product"
    has_many :participants, class_name: "Participant"

    def self.supports_v2_api?
      false
    end
  end
end
