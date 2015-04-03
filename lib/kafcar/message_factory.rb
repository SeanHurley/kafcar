module Kafcar
  module RequestTypes
    PRODUCE_REQUEST           =  0
    FETCH_REQUEST             =  1
    OFFSET_REQUEST            =  2
    METADATA_REQUEST          =  3
    OFFSET_COMMIT_REQUEST     =  8
    OFFSET_FETCH_REQUEST      =  9
    CONSUMER_METADATA_REQUEST = 10
  end

  class MessageFactory
    def self.build_metadata_request(client_id, *topics)
      topics.flatten!
      message = base_message(client_id)
      message << [topics.length].pack("l>")
      topics.each do |topic|
        message << encode_string(topic)
      end
      create_finalized_message(message)
    end

    private
    def self.base_message(client_id)
      [RequestTypes::METADATA_REQUEST, 0, 1].pack("s>s>l>") << encode_string(client_id)
    end

    def self.create_finalized_message(message)
      [message.size].pack("l>") << message
    end

    def self.encode_string(string)
      size = -1
      if string.nil?
        string = ""
      else
        size = string.size
      end
      [size, string].pack("s>A#{string.size}")
    end
  end
end
