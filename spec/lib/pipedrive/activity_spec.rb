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

  describe "api version behavior" do
    context "when global Pipedrive is set to v2" do
      before { Pipedrive.use_v2_api! }
      after { Pipedrive.use_v2_api! }

      it "uses v2 for general operations" do
        expect(described_class.api_version).to eq(:v2)
      end

      it "uses v1 specifically for fields operations" do
        expect(described_class.fields_api_version).to eq(:v1)
      end
    end

    context "when global Pipedrive is set to v1" do
      before { Pipedrive.use_v1_api! }
      after { Pipedrive.use_v2_api! }

      it "uses v1 for general operations" do
        expect(described_class.api_version).to eq(:v1)
      end

      it "still uses v1 for fields operations" do
        expect(described_class.fields_api_version).to eq(:v1)
      end
    end
  end

  describe "fields version override" do
    it "overrides fields version independently of general API version" do
      Pipedrive.use_v2_api!

      # General API operations use v2
      expect(Pipedrive.api_version).to eq(:v2)
      expect(described_class.api_version).to eq(:v2)

      # But fields operations use v1
      expect(described_class.fields_api_version).to eq(:v1)
    end

    it "responds to fields_api_version method" do
      expect(described_class).to respond_to(:fields_api_version)
    end

    it "responds to use_fields_version method" do
      expect(described_class).to respond_to(:use_fields_version)
    end
  end
end
