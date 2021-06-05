# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::LeadLabel, type: :resource do
  describe "#resources_url" do
    it "sets to leadLabels" do
      expect(described_class.resources_url).to eq("leadLabels")
    end
  end
end
