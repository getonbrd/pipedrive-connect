# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::PipedriveError do
  describe "#initialize" do
    context "message and code are optional" do
      it "creates an instance" do
        expect(subject.code).to be_nil
        expect(subject.message).to be_empty
      end
    end
  end

  describe "#message" do
    context "with code" do
      subject { described_class.new("Whatever error", 500) }

      it "includes code and message" do
        expect(subject.message).to eq("(Status 500) Whatever error")
      end
    end

    context "without code" do
      subject { described_class.new("Whatever error") }

      it "includes only the message" do
        expect(subject.message).to eq("Whatever error")
      end
    end
  end
end
