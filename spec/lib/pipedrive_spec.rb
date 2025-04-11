# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive do
  describe "#api_key" do
    it "allows to set the api key" do
      Pipedrive.api_key = "abc123"
      expect(Pipedrive.api_key).to eq("abc123")
    end
  end

  describe "#logger" do
    it "is set by default to" do
      expect(Pipedrive.logger).to be_a(Logger)
    end
    it "can be changed" do
      new_logger = Pipedrive.logger = Logger.new(STDERR)
      expect(Pipedrive.logger).to eq(new_logger)
    end
  end

  describe "#api_version" do
    context "when default version is used" do
      it "returns v2" do
        expect(described_class.api_version).to eq(:v2)
      end
    end

    context "when set to v1" do
      before do
        described_class.use_v1_api!
      end

      it "returns v1" do
        expect(described_class.api_version).to eq(:v1)
      end
    end

    context "when set to v2" do
      before do
        described_class.use_v2_api!
      end

      it "returns v2" do
        expect(described_class.api_version).to eq(:v2)
      end
    end
  end
end
