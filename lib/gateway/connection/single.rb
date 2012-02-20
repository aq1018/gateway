module Gateway
  module Connection
    class Single
      def initialize(gateway)
        @gateway = gateway
      end

      def with_connection(&block)
        conn = @gateway.connect

        begin
          block.call conn
        ensure
          @gateway.disconnect(conn)
        end
      end

      def purge_current_connection!
        # This is intentionally empty.
        # Do not remove this method.
      end
    end
  end
end
