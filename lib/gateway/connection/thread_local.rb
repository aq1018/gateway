# Thread Local connection strategy
# Expects #name, #connect, #disconnect from gateway
module Gateway
  module Connection
    class ThreadLocal
      def initialize(gateway)
        @gateway = gateway
      end

      def with_connection(&block)
        conn = thread_local_connection
        block.call conn
      end

      def purge_current_connection!
        Thread.current[thread_local_connection_name] = nil
      end

      protected

      def thread_local_connection_name
        "#{self.class.name}:#{self.object_id}"
      end

      def thread_local_connection
        Thread.current[thread_local_connection_name] ||= @gateway.connect
      end
    end
  end
end
