# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::Util do
  describe "#raise_error" do
    context "404 status" do
      it "raises a Pipedrive::NotFoundError error" do
        expect do
          described_class.raise_error(404, error: "Whatever not found")
        end.to raise_error(Pipedrive::NotFoundError, /Whatever not found/)
      end
    end
    context "unknown status" do
      it "raises a Pipedrive::UnkownAPIError error" do
        expect do
          described_class.raise_error(999, error: "Unknown error")
        end.to raise_error(Pipedrive::UnkownAPIError, /Unknown error/)
      end
    end
  end
end
