module Gateway
  module Connection
    include Single
    include ThreadLocal
    include Pool

    def purge_current_connection!
      send "purge_current_connection_from_#{connection_type}!"
    end

    protected

    def connect
      raise "Abstract Method"
    end

    def disconnect(conn)
      raise "Abstract Method"
    end

    def reconnect(conn)
      raise "Abstract Method"
    end

    def connection_type
      @connection_type ||= (options[:connection_type] || :thread_local)
    end

    def with_connection(opts={}, &block)
      return with_single(&block) if opts[:persistent] == false
      send "with_#{connection_type}", &block
    end
  end
end
