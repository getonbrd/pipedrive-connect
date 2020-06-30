# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::ActivityType, type: :resource do
  describe "#resources_url" do
    it "set to activityTypes" do
      expect(described_class.resources_url).to eq("activityTypes")
    end
  end
end
