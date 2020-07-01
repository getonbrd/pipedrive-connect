# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::Activity, type: :resource do
  describe "#resources_url" do
    it "sets to activities" do
      expect(described_class.resources_url).to eq("activities")
    end
  end

  describe "methods" do
    it "responds to fields" do
      expect(subject).to respond_to(:fields)
    end
  end
end
