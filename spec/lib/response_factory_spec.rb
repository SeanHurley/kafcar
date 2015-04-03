require 'spec_helper'

describe Kafcar::ResponseFactory do
  context "self.build_metadata_response" do
    it "builds a response from all topic metadata" do
      response = Kafcar::ResponseFactory.build_metadata_response("\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\r10.227.248.45\x00\x00#\x84\x00\x00\x00\x01\x00\x00\x00\x04test\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00".force_encoding(Encoding::ASCII_8BIT))

      topic = response.topics.first
      expect(response.topics.length).to eq(1)
      expect(topic.name).to eq("test")
      expect(topic.error_code).to eq(0)
      expect(topic.partitions.length).to eq(1)
      partition = topic.partitions.first
      expect(partition.id).to eq(0)
      expect(partition.error_code).to eq(0)
      expect(partition.leader).to eq(0)
      expect(partition.replicas).to eq([0])
      expect(partition.isr).to eq([0])
    end

    it "parses multiple topics" do
      response = Kafcar::ResponseFactory.build_metadata_response("\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x00\x00\r10.227.248.45\x00\x00#\x84\x00\x00\x00\x02\x00\x00\x00\x05test2\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x04test\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00".force_encoding(Encoding::ASCII_8BIT))

      expect(response.topics.length).to eq(2)
      expect(response.topics[0].name).to eq("test2")
      expect(response.topics[1].name).to eq("test")
    end
  end
end
