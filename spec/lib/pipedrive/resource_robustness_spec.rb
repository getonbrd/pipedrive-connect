# frozen_string_literal: true

require "spec_helper"

module Pipedrive
  # Never instantiated through #initialize before these specs, like a class in a
  # fresh process that only sees objects loaded from a cache.
  class CachedThing < Resource
    self.resources_url = "cachedthings"
  end
end

RSpec.describe Pipedrive::Resource do
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:conn)  { Faraday.new { |b| b.adapter(:test, stubs) } }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
    Pipedrive.api_key = "token"
  end

  after { Pipedrive.api_key = nil }

  def json_response(data)
    [200, { "Content-Type": "application/json" }, { success: true, data: data }.to_json]
  end

  describe "an object marshaled by an earlier version (no #marshal_load)" do
    # Old cache entries hold only the instance variables; loading them skips
    # #initialize, so the class never got its accessors.
    subject(:cached) do
      Pipedrive::CachedThing.allocate.tap do |thing|
        thing.instance_variable_set(:@data, { id: 7, name: "Get on Board" })
        thing.instance_variable_set(:@unsaved_data, {})
      end
    end

    it "still has its id and attributes" do
      expect(cached.id).to eq(7)
      expect(cached.name).to eq("Get on Board")
      expect(cached).to respond_to(:name)
    end

    it "can be updated" do
      stubs.put("cachedthings/7") { json_response(id: 7, name: "New") }

      cached.update(name: "New")

      expect(cached.name).to eq("New")
      stubs.verify_stubbed_calls
    end

    it "still raises NoMethodError for an attribute it does not have" do
      expect { cached.unknown_attribute }.to raise_error(NoMethodError)
    end
  end

  describe "Marshal round trip" do
    it "keeps the data and the accessors" do
      original = Pipedrive::CachedThing.new(id: 3, name: "Acme")
      loaded = Marshal.load(Marshal.dump(original))

      expect(loaded.id).to eq(3)
      expect(loaded.name).to eq("Acme")
    end
  end

  describe "#update with nothing to send" do
    it "makes no request" do
      thing = Pipedrive::CachedThing.new(id: 1, name: "Acme")

      expect(thing.update({})).to eq(id: 1, name: "Acme")
      # No stub is registered: any request would raise Stubs::NotFound.
    end
  end

  describe "a non-JSON response body" do
    def html(status)
      [status, { "Content-Type": "text/html" }, "<!doctype html><html>Bad gateway</html>"]
    end

    it "raises the error for its status" do
      stubs.get("cachedthings/1") { html(503) }

      expect { Pipedrive::CachedThing.retrieve(1) }
        .to raise_error(Pipedrive::ServiceUnavailableError, /HTTP 503 with a non-JSON/)
    end

    it "raises InvalidResponseError for a status without its own error" do
      stubs.get("cachedthings/1") { html(502) }

      expect { Pipedrive::CachedThing.retrieve(1) }
        .to raise_error(Pipedrive::InvalidResponseError) { |e| expect(e.code).to eq(502) }
    end

    it "raises InvalidResponseError for a 200 that is not JSON" do
      stubs.get("cachedthings/1") { html(200) }

      expect { Pipedrive::CachedThing.retrieve(1) }.to raise_error(Pipedrive::InvalidResponseError)
    end
  end
end
