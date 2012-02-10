module Gateway
  class Error < RuntimeError
    attr_accessor :status, :inner_error
    def self.wrap(error)
      e = self.new("#{self.name} - #{error.class.name}: #{error.message}")
      e.inner_error = error
      e
    end
  end

  # When backend stops responding within given time.
  class GatewayTimeout < Error
    def initialize(msg)
      super
      self.status = "504"
    end
  end

  # When backend did not send back an (processible) response.
  # Usually when connection is dropped.
  class BadGateway < Error
    def initialize(msg)
      super
      self.status = "502"
    end
  end

  # When a response is returned, but is considered unsuccessful.
  # This is application specific.
  # For HTTP responses: 4xx, 5xx can be considered bad response
  class BadResponse < BadGateway
    attr_accessor :info
    def initialize(msg, info=nil)
      msg = "#{msg}\nInfo:\n#{info.inspect}" if info
      super msg
      self.info = info
    end
  end
end
