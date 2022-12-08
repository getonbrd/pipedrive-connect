# frozen_string_literal: true

module Pipedrive
  class LeadLabel < Resource
    self.resources_url = "leadLabels"
    update_method :patch
  end
end
