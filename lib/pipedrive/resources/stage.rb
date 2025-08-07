# frozen_string_literal: true

module Pipedrive
  class Stage < Resource
    def self.supports_v2_api?
      true
    end
  end
end
