# frozen_string_literal: true

module Pipedrive
  class Deal < Resource
    include Fields
    include Merge

    has_many :products, class_name: "Product"
    has_many :participants, class_name: "Participant"
  end
end
