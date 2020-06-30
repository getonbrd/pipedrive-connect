# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::CallLog, type: :resource do
  describe "#resources_url" do
    it "sets to callLogs" do
      expect(described_class.resources_url).to eq("callLogs")
    end
  end
end
