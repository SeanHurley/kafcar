require 'spec_helper'

describe Kafcar::Client do
  let(:client) { Kafcar::Client.new("localhost:9092", "test") }

  describe "metadata" do
    after(:each) do
      client.close
    end

    it "fetches metadata for all topics if no topics are requested" do
      data = client.fetch_metadata

      expect(data.topics.length).to be > 0
    end

    it "can fetch metadata for specific topics" do
      data = client.fetch_metadata("test", "test2")

      topics = data.topics.map(&:name)
      expect(topics.length).to eq(2)
      expect(topics).to match_array(["test", "test2"])
    end
  end

  describe "close" do
    it "closes the TCPSocket" do
      expect_any_instance_of(TCPSocket).to receive(:close)

      client.close
    end
  end
end
