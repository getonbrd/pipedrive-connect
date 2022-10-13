# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::Subscription, type: :resource do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
    allow(Pipedrive).to receive(:api_key).and_return("abc123")
  end

  it "is a Resource" do
    expect(subject).to be_a(Pipedrive::Resource)
  end

  describe "#create_recurring" do
    before do
      stubs.post("subscriptions/recurring") do
        [
          200,
          { "Content-Type": "application/json" },
          {
            success: true,
            data: {
              id: 1,
              name: "Subscription",
            },
          }.to_json,
        ]
      end
    end

    context "valid" do
      it "adds the product and returns its instance" do
        p = described_class.create_recurring(deal_id: 2, currency: "USD")
        expect(p).to be_a(Pipedrive::Subscription)
        expect(p.id).to be(1)
        expect(p.name).to eq("Subscription")
      end
    end
  end
  
  describe "#find_by_deal" do
    deal_id = 2
    before do
      stubs.get("subscriptions/find/#{deal_id}") do
        [
          200,
          { "Content-Type": "application/json" },
          {
            success: true,
            data: {
              id: 1,
              deal_id: deal_id,
            },
          }.to_json,
        ]
      end
    end

    it "returns a subscription connected to the deal" do
      p = described_class.find_by_deal(deal_id)
      expect(p).to be_a(Pipedrive::Subscription)
      expect(p.id).to be(1)
      expect(p.deal_id).to be(2)
    end
  end

  describe "#update_recurring" do
    subject { described_class.new(id: 1, name: "My Subscription") }
    before do
      stubs.put("subscriptions/recurring/#{subject.id}") do
        [
          200,
          { "Content-Type": "application/json" },
          {
            success: true,
            data: {
              id: 1,
              name: "Updated Subscription",
            },
          }.to_json,
        ]
      end
    end

    it "updates the subscriptions and returns the updated subscription object" do
      sub = subject.update_recurring
      expect(sub).to be_a(Pipedrive::Subscription)
      expect(sub.id).to be(1)
      expect(sub.name).to eq("Updated Subscription")
    end
  end

  describe "#cancel_recurring" do
    subject { described_class.new(id: 1) }
    before do
      stubs.put("subscriptions/recurring/#{subject.id}/cancel") do
        [
          200,
          { "Content-Type": "application/json" },
          {
            success: true,
            data: {
              id: 1,
              name: "Subscription",
            },
          }.to_json,
        ]
      end
    end

    it "cancels the subscriptions and returns the updated subscription object" do
      sub = subject.cancel_recurring
      expect(sub).to be_a(Pipedrive::Subscription)
      expect(sub.id).to be(1)
      expect(sub.name).to eq("Subscription")
    end
  end
end
