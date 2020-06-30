# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::Currency, type: :resource do
  describe "#resources_url" do
    it "sets to currencies" do
      expect(described_class.resources_url).to eq("currencies")
    end
  end
end
