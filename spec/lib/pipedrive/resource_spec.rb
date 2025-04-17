# frozen_string_literal: true

require "spec_helper"

module Pipedrive
  class Resourceable < Resource
    include Fields
    self.resources_url = "resourceables"
    self.fields_url = "resourceableFields"
  end
end

RSpec.describe Pipedrive::Resourceable do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
    stubs.get("resourceableFields") do
      [
        200,
        { "Content-Type": "application/json" },
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

  describe "#api_base_url" do
    context "when it supports v2 api" do
      before do
        allow(described_class).to receive(:supports_v2_api?).and_return(true)
      end

      it "returns v2 expected url" do
        expect(described_class.api_base_url).to eq("https://api.pipedrive.com/api/v2")
      end
    end

    context "when it does not support v2 api" do
      before do
        allow(described_class).to receive(:supports_v2_api?).and_return(false)
      end

      it "returns v1 expected url" do
        expect(described_class.api_base_url).to eq("https://api.pipedrive.com/v1")
      end
    end
  end

  describe "#class_name" do
    it "returns the name of the scoped class" do
      expect(described_class.class_name).to eq("Resourceable")
    end
  end

  describe "#resource_url" do
    it "raises error if called the abstract method" do
      expect do
        Pipedrive::Resource.resource_url
      end.to raise_error(Pipedrive::NotImplementedError, /Pipedrive::Resource is an abstract class/)
    end
  end

  context "No api_key set" do
    before do
      allow(Pipedrive).to receive(:api_key).and_return(nil)
    end

    it "raises an error" do
      expect do
        described_class.retrieve(1)
      end.to raise_error Pipedrive::AuthenticationError
    end
  end

  context "api_key set" do
    before do
      allow(Pipedrive).to receive(:api_key).and_return("abc123")
    end

    describe "#all" do
      context "no data" do
        before do
          stubs.get("resourceables") do
            [
              200,
              { 'Content-Type': "application/json" },
              { "data": [] }.to_json,
            ]
          end
        end

        it "returns an empty array" do
          expect(described_class.all).to eq([])
        end
      end

      context "with data" do
        before do
          stubs.get("resourceables") do
            [
              200,
              { 'Content-Type': "application/json" },
              {
                "data": [{
                  "id": 1,
                  "name": "R1",
                }, {
                  "id": 2,
                  "name": "R2",
                },],
              }.to_json,
            ]
          end

          it "returns the array of instances" do
            all = described_class.all
            expect(all).to be_present
            expect(all.count).to be 2
            expect(all.first).to be_a(described_class)
            expect(all.first.id).to be 1
            expect(all.first.name).to be "R1"
            expect(all.last.id).to be 2
            expect(all.last.name).to be "R2"
          end
        end
      end
    end

    describe "#search" do
      context "no data" do
        before do
          stubs.get("resourceables/search") do |env|
            expect(env.params).to include("term" => "Get on Board")
            [
              200,
              { 'Content-Type': "application/json" },
              { "data": { items: [] } }.to_json,
            ]
          end
        end

        it "returns an empty array" do
          expect(described_class.search("Get on Board")).to eq([])
        end
      end

      context "with data" do
        before do
          stubs.get("resourceables/search") do |_env|
            expect(env.params).to include(
              "term" => "Get on Board",
              "fields" => %i[name address].join(","),
              "exact_match" => true
            )
            [
              200,
              { 'Content-Type': "application/json" },
              {
                "data": {
                  items: [{
                    "id": 1,
                    "name": "R1",
                  }, {
                    "id": 2,
                    "name": "R2",
                  },],
                },
              }.to_json,
            ]
          end

          it "returns the array of instances" do
            all = described_class.search("Get on Board",
                                         exact_match: true,
                                         fields: %i[name address])
            expect(all).to be_present
            expect(all.count).to be 2
            expect(all.first).to be_a(described_class)
            expect(all.first.id).to be 1
            expect(all.first.name).to be "R1"
            expect(all.last.id).to be 2
            expect(all.last.name).to be "R2"
          end
        end
      end
    end

    describe "#retrieve" do
      context "not found" do
        before do
          stubs.get("resourceables/1") do
            [
              404,
              { 'Content-Type': "application/json" },
              { "error": "Resourceable not found" }.to_json,
            ]
          end
        end

        it "raise NotFoundError" do
          expect do
            described_class.retrieve(1)
          end.to raise_error Pipedrive::NotFoundError
        end
      end

      context "found" do
        before do
          stubs.get("resourceables/1") do
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

        subject { described_class.retrieve(1) }

        it "returns an Resourceable instance" do
          expect(subject.id).to eq(1)
          expect(subject.name).to eq("Get on Board")
          expect(subject.domain).to eq("example.com")
        end
      end

      context "no content" do
        before do
          stubs.get("resourceables/1") do
            [
              204,
              { 'Content-Type': "application/json" },
            ]
          end
        end

        subject { described_class.retrieve(1) }

        it "returns an Resourceable instance with no data" do
          expect(subject.empty?).to be_truthy
        end

        context "treat 204 as 404" do
          before do
            allow(Pipedrive).to receive(:treat_no_content_as_not_found).and_return(true)
          end

          it "raises 404 Not found error" do
            expect do
              described_class.retrieve(1)
            end.to raise_error Pipedrive::NotFoundError
          end
        end
      end
    end

    describe "#refresh" do
      before do
        stubs.get("resourceables/1") do
          [
            200,
            { 'Content-Type': "application/json" },
            {
              success: true,
              data: {
                id: 1,
                name: "Get on Board",
                method: "method",
                description: "Job platform",
                checked: true,
                "abcdefghijklmnopqrstuvwsyz": "example.com",
              },
            }.to_json,
          ]
        end
      end

      subject { described_class.new(id: 1) }

      it "returns an Resourceable instance" do
        subject.refresh
        expect(subject.id).to eq(1)
        expect(subject.name).to eq("Get on Board")
        expect(subject.domain).to eq("example.com")
        expect(subject.method).to eq("method")
        expect(subject.checked?).to be(true)
        subject.description = "Awesome Job for awesome people"
        expect(subject.description).to eq("Awesome Job for awesome people")
      end
    end

    describe "#create" do
      before do
        stubs.post("resourceables") do |env|
          req_body = JSON.parse(env.body, symbolize_names: true)
          expect(req_body).to include(
            name: "Get on Board",
            address: "CL/PE/US",
            "abcdefghijklmnopqrstuvwsyz": "newdomain.com"
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

      subject do
        described_class.create(
          name: "Get on Board",
          address: "CL/PE/US",
          domain: "newdomain.com"
        )
      end

      it "sends a post request and creates an instance of Resourceables" do
        expect(subject.id).to eq(1)
        expect(subject.name).to eq("Get on Board")
      end
    end

    describe "#update" do
      before do
        stubs.put("resourceables/1") do |env|
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

      subject do
        described_class.new(
          id: 1,
          name: "Another name",
          address: "Another address"
        )
      end

      it "sends put request and updates the instance's attribute" do
        subject.update(
          name: "Get on Board",
          address: "CL/PE/US"
        )
        expect(subject.id).to eq(1)
        expect(subject.name).to eq("Get on Board")
        expect(subject.address).to eq("CL/PE/US")
      end
    end

    describe "#delete" do
      before do
        stubs.delete("resourceables/1") do
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

      subject do
        described_class.new(
          id: 1,
          name: "Get on Board",
          address: "CL/PE/US"
        )
      end

      it "sends a delete request and keeps the copy locally" do
        subject.delete
        expect(subject.id).to eq(1)
        expect(subject.name).to eq("Get on Board")
        expect(subject.address).to eq("CL/PE/US")
      end
    end
  end

  describe "#fields" do
    before do
      allow(described_class).to receive(:fields)
    end

    it "calls the classs method" do
      expect(described_class).to receive(:fields)
      subject.fields
    end
  end

  describe "#has_many" do
    context "wrongly defined" do
      it "raises error" do
        expect do
          described_class.has_many(:whatever, class_name: nil)
        end.to raise_error(/You must specify the resource name and its class name/)
      end
    end

    context "correctly defined" do
      module Pipedrive
        class Whatever < Resource; end
      end
      before do
        allow(Pipedrive).to receive(:api_key).and_return("abc123")
        stubs.get("resourceables/1/whatevers") do
          [
            200,
            { "Content-Type": "application/json" },
            {
              success: true,
              data: [{
                id: 1,
                name: "Whatever",
              }],
            }.to_json,
          ]
        end
      end

      subject { described_class.new(id: 1) }

      it "creates a new method" do
        described_class.has_many(:whatevers, class_name: "Whatever")
        expect(subject).to respond_to(:whatevers)
        expect(subject.whatevers.count).to be(1)
      end

      context "creates the add and delete methods on the association" do
        let(:attached_resource_id) { 99 }
        before do
          stubs.post("resourceables/1/whatevers") do |env|
            req_body = JSON.parse(env.body, symbolize_names: true)
            expect(req_body).to include(name: "New resource")
            [
              200,
              { 'Content-Type': "application/json" },
              {
                success: true,
                data: {
                  id: 1,
                  name: "New resource",
                },
              }.to_json,
            ]
          end

          stubs.delete("resourceables/1/whatevers/#{attached_resource_id}") do
            [
              200,
              { 'Content-Type': "application/json" },
              {
                success: true,
                data: {},
              }.to_json,
            ]
          end
        end

        it "allows adding a resource" do
          described_class.has_many(:whatevers, class_name: "Whatever")
          expect(subject).to respond_to(:add_whatever)

          expect(subject.add_whatever(name: "New resource")).to be_truthy
        end

        it "allows to delete a resource" do
          described_class.has_many(:whatevers, class_name: "Whatever")
          expect(subject.delete_whatever(attached_resource_id)).to be_truthy
        end
      end
    end
  end
end
