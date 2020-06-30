# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::GlobalMessage, type: :resource do
  describe "#resources_url" do
    it "set to globalMessages" do
      expect(described_class.resources_url).to eq("globalMessages")
    end
  end
end
