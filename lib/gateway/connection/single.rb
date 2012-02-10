module Gateway
  module Connection
    module Single
      protected
      def with_single(&block)
        conn = connect
        begin
          block.call conn
        ensure
          disconnect(conn)
        end
      end

      def purge_current_connection_from_single!
        # This is intentionally empty.
        # Do not remove this method.
      end
    end
  end
end
