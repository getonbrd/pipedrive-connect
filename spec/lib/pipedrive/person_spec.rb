# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::Person, type: :resource do
  describe "methods" do
    it "responds to fields" do
      expect(subject).to respond_to(:fields)
    end
    it "responds to merge" do
      expect(subject).to respond_to(:merge)
    end
    it "responds to deals" do
      expect(subject).to respond_to(:deals)
    end
  end
end
