# frozen_string_literal: true

require "spec_helper"

module Pipedrive
  class Mergeable < Resource
    include Merge
    self.resources_url = "mergeables"
  end
end

RSpec.describe Pipedrive::Mergeable do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe "#merge" do
    let(:mergeable) { Pipedrive::Mergeable.new(id: 1) }

    before do
      allow(Pipedrive).to receive(:api_key).and_return("abc123")

      stubs.put("mergeables/1/merge") do |env|
        req_body = JSON.parse(env.body, symbolize_names: true)
        expect(req_body).to include(merge_with_id: 2)
        [
          200,
          { "Content-Type": "application/json" },
          {
            success: true,
            data: {
              id: 1,
              name: "Mergeable",
            },
          }.to_json,
        ]
      end
    end

    context "missing or wrong params" do
      it "raises error when a with_id is not an integer" do
        expect do
          subject.merge(with_id: "123")
        end.to raise_error("with_id must be an integer")
      end
    end

    context "valid" do
      subject { described_class.new(id: 1) }
      it "merges the resources" do
        m = subject.merge(with_id: 2)
        expect(m).to be_a(Pipedrive::Mergeable)
        expect(m.id).to be(1)
        expect(m.name).to eq("Mergeable")
      end
    end
  end
end
