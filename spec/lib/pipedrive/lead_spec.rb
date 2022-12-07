# frozen_string_literal: true

require "spec_helper"

RSpec.describe Pipedrive::Lead, type: :resource do
  it "is a Resource" do
    expect(subject).to be_a(Pipedrive::Resource)
  end

  it "overrides the update_method with patch" do
    expect(subject.update_method).to eq(:patch)
  end

  it "uses patch method when updating resource" do
    def subject.id; 1; end
    expect(Pipedrive::Lead).to receive(:request).with(:patch, anything, anything).and_return({
      data: {}
    })
    subject.update(title: 'ABCDEFG')
  end
end
