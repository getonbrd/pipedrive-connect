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

  describe "v1 api version" do
    before do
      Pipedrive.use_v1_api!
    end

    after do
      Pipedrive.use_v2_api!
    end

    it "returns v1 api version" do
      expect(described_class.api_version).to eq(:v1)
    end
  end

  describe "default v2 api version" do
    it "returns v2 api version" do
      expect(described_class.api_version).to eq(:v2)
    end
  end
end
