# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::Organization, type: :resource do
  describe "methods" do
    it "responds to fields" do
      expect(subject).to respond_to(:fields)
    end
    it "responds to activities" do
      expect(subject).to respond_to(:activities)
    end
    it "responds to deals" do
      expect(subject).to respond_to(:deals)
    end
    it "responds to persons" do
      expect(subject).to respond_to(:persons)
    end
  end
end
