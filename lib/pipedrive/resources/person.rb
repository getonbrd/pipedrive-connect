# frozen_string_literal: true

module Pipedrive
  class Person < Resource
    include Fields
    include Merge

    has_many :deals, class_name: "Deal"
    has_many :activities, class_name: "Activity"
  end
end
