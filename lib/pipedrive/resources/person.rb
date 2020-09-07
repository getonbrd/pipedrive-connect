# frozen_string_literal: true

module Pipedrive
  class Person < Resource
    include Fields
    include Merge
  end
end
