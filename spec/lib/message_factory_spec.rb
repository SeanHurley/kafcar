require 'spec_helper'

describe Kafcar::MessageFactory do
  context "self.build_metadata_request" do
    it "builds a request for all topic metadata if provided no topics" do
      request = Kafcar::MessageFactory.build_metadata_request("test")

      expect(request).to eq("\x00\x00\x00\x12\x00\x03\x00\x00\x00\x00\x00\x01\x00\x04test\x00\x00\x00\x00".force_encoding(Encoding::ASCII_8BIT))
    end

    it "builds a request for specific topic data with an arry" do
      request = Kafcar::MessageFactory.build_metadata_request("test", ["topic1", "topic2"])

      expect(request).to eq("\x00\x00\x00\"\x00\x03\x00\x00\x00\x00\x00\x01\x00\x04test\x00\x00\x00\x02\x00\x06topic1\x00\x06topic2".force_encoding(Encoding::ASCII_8BIT))
    end

    it "builds a request for specific topic data with multiple args" do
      request = Kafcar::MessageFactory.build_metadata_request("test", "topic1", "topic2")

      expect(request).to eq("\x00\x00\x00\"\x00\x03\x00\x00\x00\x00\x00\x01\x00\x04test\x00\x00\x00\x02\x00\x06topic1\x00\x06topic2".force_encoding(Encoding::ASCII_8BIT))
    end
  end
end
