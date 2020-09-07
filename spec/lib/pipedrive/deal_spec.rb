# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::Deal, type: :resource do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }

  before do
    allow(Faraday).to receive(:new).and_return(conn)
  end

  describe "methods" do
    it "responds to fields" do
      expect(subject).to respond_to(:fields)
    end
    it "responds to products" do
      expect(subject).to respond_to(:products)
    end
    it "responds to merge" do
      expect(subject).to respond_to(:merge)
    end
  end

  describe "#add_product" do
    let(:product) { Pipedrive::Product.new(id: 1) }
    before do
      allow(Pipedrive).to receive(:api_key).and_return("abc123")
      stubs.get("dealFields") do
        [
          200,
          { "Content-Type": "application/json" },
          {
            success: true,
            data: [],
          }.to_json,
        ]
      end

      stubs.get("productFields") do
        [
          200,
          { "Content-Type": "application/json" },
          {
            success: true,
            data: [],
          }.to_json,
        ]
      end

      stubs.post("deals/1/products") do
        [
          200,
          { "Content-Type": "application/json" },
          {
            success: true,
            data: {
              id: 1,
              name: "Product",
            },
          }.to_json,
        ]
      end
    end

    context "missing or wrong params" do
      it "raises error when a product param of a wrong type is sent" do
        expect do
          subject.add_product("whatever", {})
        end.to raise_error(
          "Param *product* is not an instance of Pipedrive::Product"
        )
      end
      it "raises error when item price is missing" do
        expect do
          subject.add_product(product, {})
        end.to raise_error(
          "Param :item_price is required"
        )
      end
      it "raises error when quantity is missing" do
        expect do
          subject.add_product(product, { item_price: 1 })
        end.to raise_error(
          "Param :quantity is required"
        )
      end
    end

    context "valid" do
      subject { described_class.new(id: 1) }
      it "adds the product and return its instance" do
        p = subject.add_product(product, item_price: 1, quantity: 1)
        expect(p).to be_a(Pipedrive::Product)
        expect(p.id).to be(1)
        expect(p.name).to eq("Product")
      end
    end
  end
end
