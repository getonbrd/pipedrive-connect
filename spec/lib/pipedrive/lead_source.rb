# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::LeadSource, type: :resource do
  it "is a Resource" do
    expect(subject).to be_a(Pipedrive::Resource)
  end

  describe "#resources_url" do
    it "sets to leadSources" do
      expect(described_class.resources_url).to eq("leadSources")
    end
  end
end
