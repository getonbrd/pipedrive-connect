# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::User, type: :resource do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
    allow(Pipedrive).to receive(:api_key).and_return("abc123")
  end

  it "is a Resource" do
    expect(subject).to be_a(Pipedrive::Resource)
  end

  describe "#find" do
    context "no data" do
      before do
        stubs.get("users/find") do |env|
          expect(env.params).to include("term" => "Not existing")
          [
            200,
            { "Content-Type": "application/json" },
            { data: [] }.to_json,
          ]
        end
      end

      it "returns an empty array" do
        expect(described_class.find("Not existing", false)).to eq([])
      end
    end

    context "with data" do
      before do
        stubs.get("users/find") do |_env|
          expect(env.params).to include("term" => "Test User")
          [
            200,
            { "Content-Type": "application/json" },
            {
              data: [{
                id: 1,
                name: "Test User",
                email: "test@test.fr",
              }],
            }.to_json,
          ]
        end

        it "returns the array of instances" do
          all = described_class.find("Test User", false)

          expect(all).to be_present
          expect(all.count).to be 1
          expect(all.first).to be_a(described_class)
          expect(all.first.id).to be 1
          expect(all.first.name).to be "Test User"
          expect(all.first.email).to be "test@test.fr"
        end
      end
    end
  end
end
