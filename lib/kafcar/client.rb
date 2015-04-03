require "socket"

module Kafcar
  class Client
    attr_accessor :host, :topic

    def initialize(kafka_host, kafka_topic)
      @host = kafka_host
      @topic = kafka_topic
    end

    def fetch_metadata(*topics)
      topics.flatten!
      message = MessageFactory.build_metadata_request("test", topics)
      connection.write(message)
      read_data = connection.recv(4)
      raise "Error reading metadata from cluster" if read_data.nil?
      read_length = read_data.unpack("L>").first
      ResponseFactory.build_metadata_response(connection.recv(read_length))
    end

    def close
      connection.close
    end

    private
    def connection
      return @connection if defined? @connection

      ip, port = host.split(":")
      @connection ||= TCPSocket.new(ip, port)
    end
  end
end
