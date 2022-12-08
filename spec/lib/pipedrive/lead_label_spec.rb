# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::LeadLabel, type: :resource do
  describe "#resources_url" do
    it "sets to leadLabels" do
      expect(described_class.resources_url).to eq("leadLabels")
    end
  end

  describe "update method" do
    it "overrides the update_method with patch" do
      expect(subject.update_method).to eq(:patch)
    end

    it "uses patch method when updating resource" do
      def subject.id
        1
      end

      expect(Pipedrive::LeadLabel)
        .to receive(:request)
        .with(:patch, anything, anything)
        .and_return({ data: {} })

      subject.update(name: "ABCDEFG")
    end
  end
end
