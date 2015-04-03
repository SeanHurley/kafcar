require 'ostruct'

module Kafcar
  class ResponseFactory
    def self.build_metadata_response(data)
      start = 0
      #correlation_id = data.unpack("l>")
      start += 4
      brokers, length = parse_brokers(data.byteslice(start, data.size-start))
      start += length
      topics, _ = parse_topics(data.byteslice(start, data.size - start))
      OpenStruct.new(:topics => topics, :brokers => brokers)
    end

    private
    def self.parse_brokers(data)
      start = 0
      num_brokers = data.unpack("l>").first
      start += 4
      brokers = num_brokers.enum_for(:times).map do
        broker, len = parse_broker(data.byteslice(start, data.size-start))
        start += len
        broker
      end
      [brokers, start]
    end

    def self.parse_broker(data)
      start = 0
      node_id = data.unpack("l>").first
      start += 4
      host, len = parse_string(data.byteslice(start, data.size-start))
      start += len
      port = data.byteslice(start, data.size-start).unpack("l>").first
      start += 4
      [{:id => node_id, :host => host, :port => port}, start]
    end

    def self.parse_topics(data)
      start = 0
      ret = []
      num_topics = data.unpack("l>").first
      start += 4
      num_topics.times do
        error_code = data.byteslice(start, data.size-start).unpack("s>").first
        start += 2
        name, len = parse_string(data.byteslice(start, data.size-start))
        start += len
        partition_metadata, len = parse_partition_metadata(data.byteslice(start, data.size-start))
        topic = OpenStruct.new(
          :name => name,
          :error_code => error_code,
          :partitions => partition_metadata,
        )
        ret << topic
        start += len
      end
      [ret, start]
    end

    def self.parse_partition_metadata(data)
      start = 0
      npartitions, len = data.unpack("l>")
      start += 4
      ret = npartitions.enum_for(:times).map do
        error_code, id, leader, nreplicas = data.byteslice(start, data.size-start).unpack("s>l>l>l>")
        start += 14
        replicas = data.byteslice(start, data.size-start).unpack("l>#{nreplicas}")
        start += nreplicas * 4
        nisrs, len = data.byteslice(start, data.size-start).unpack("l>")
        start += 4
        isr = data.byteslice(start, data.size-start).unpack("l>#{nisrs}")
        start += nisrs * 4
        partition = OpenStruct.new(
          :id => id,
          :error_code => error_code,
          :leader => leader,
          :replicas => replicas,
          :isr => isr,
        )
        partition
      end
      [ret, start]
    end

    def self.parse_string(data)
      len = data.unpack("s>").first
      string = data.byteslice(2, data.size-2).unpack("A#{len}").first
      [string, len+2]
    end
  end
end
