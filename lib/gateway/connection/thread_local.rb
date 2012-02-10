module Gateway
  module Connection
    module ThreadLocal
      protected

      def with_thread_local(&block)
        conn = thread_local_connection
        block.call conn
      end

      def purge_current_connection_from_thread_local!
        Thread.current[thread_local_connection_name] = nil
      end

      def thread_local_connection_name
        "#{self.class.name}:#{self.name}"
      end

      def thread_local_connection
        Thread.current[thread_local_connection_name] ||= connect
      end
    end
  end
end
