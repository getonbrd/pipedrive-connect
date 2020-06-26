# frozen_string_literal: true

require "spec_helper"

module Pipedrive
  class ResourceDescendant < Resource
    include Fields
    self.resources_url = "resourceDescendants"
    self.fields_url = "resourceDescendantFields"
  end
end

RSpec.describe Pipedrive::ResourceDescendant do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  context "No api_key set" do
    before do
      allow(Pipedrive).to receive(:api_key).and_return(nil)
    end
    it "raises an error" do
      puts Pipedrive.api_key
      expect do
        Pipedrive::ResourceDescendant.retrieve(1)
      end.to raise_error Pipedrive::AuthenticationError
    end
  end

  context "api_key set" do
    before do
      allow(Pipedrive).to receive(:api_key).and_return("abc123")
    end
    before do
      stubs.get("resourceDescendantFields") do
        [
          200,
          { 'Content-Type': "application/json" },
          {
            success: true,
            data: [{
              key: "abcdefghijklmnopqrstuvwsyz",
              name: "Domain",
            }],
          }.to_json,
        ]
      end
    end
    describe "#retrieve" do
      context "not found" do
        before do
          stubs.get("resourceDescendants/1") do
            [
              404,
              { 'Content-Type': "application/json" },
              { "error": "ResourceDescendant not found" }.to_json,
            ]
          end
        end
        it "raise NotFoundError" do
          expect do
            Pipedrive::ResourceDescendant.retrieve(1)
          end.to raise_error Pipedrive::NotFoundError
        end
      end

      context "found" do
        before do
          stubs.get("resourceDescendants/1") do
            [
              200,
              { 'Content-Type': "application/json" },
              {
                success: true,
                data: {
                  id: 1,
                  name: "Get on Board",
                  "abcdefghijklmnopqrstuvwsyz": "example.com",
                },
              }.to_json,
            ]
          end
        end
        it "returns an ResourceDescendant instance" do
          org = Pipedrive::ResourceDescendant.retrieve(1)
          expect(org.id).to eq(1)
          expect(org.name).to eq("Get on Board")
          expect(org.domain).to eq("example.com")
        end
      end
    end

    context "#create" do
      before do
        stubs.post("resourceDescendants") do |env|
          req_body = JSON.parse(env.body, symbolize_names: true)
          expect(req_body).to include(
            name: "Get on Board",
            address: "CL/PE/US"
          )
          [
            200,
            { 'Content-Type': "application/json" },
            {
              success: true,
              data: {
                id: 1,
                name: "Get on Board",
              },
            }.to_json,
          ]
        end
      end
      it "sends a post request and creates an instance of ResourceDescendants" do
        org = Pipedrive::ResourceDescendant.create(
          name: "Get on Board",
          address: "CL/PE/US"
        )
        expect(org.id).to eq(1)
        expect(org.name).to eq("Get on Board")
      end
    end

    context "#update" do
      before do
        stubs.put("resourceDescendants/1") do |env|
          req_body = JSON.parse(env.body, symbolize_names: true)
          expect(req_body).to include(
            name: "Get on Board",
            address: "CL/PE/US"
          )
          [
            200,
            { 'Content-Type': "application/json" },
            {
              success: true,
              data: {
                id: 1,
                name: "Get on Board",
                address: "CL/PE/US",
              },
            }.to_json,
          ]
        end
      end
      it "sends put request and updates the instance's attribute" do
        org = Pipedrive::ResourceDescendant.new({
                                                  id: 1,
                                                  name: "Another name",
                                                  address: "Another address",
                                                })
        org.update(
          name: "Get on Board",
          address: "CL/PE/US"
        )
        expect(org.id).to eq(1)
        expect(org.name).to eq("Get on Board")
        expect(org.address).to eq("CL/PE/US")
      end
    end

    context "#delete" do
      before do
        stubs.delete("resourceDescendants/1") do
          [
            200,
            { 'Content-Type': "application/json" },
            {
              success: true,
              data: { id: 1 },
            }.to_json,
          ]
        end
      end
      it "sends a delete request and keeps the copy locally" do
        org = Pipedrive::ResourceDescendant.new({
                                                  id: 1,
                                                  name: "Get on Board",
                                                  address: "CL/PE/US",
                                                })
        org.delete
        expect(org.id).to eq(1)
        expect(org.name).to eq("Get on Board")
        expect(org.address).to eq("CL/PE/US")
      end
    end
  end
end
