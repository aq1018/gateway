module Gateway
  module Feature
    module ErrorHandle
      protected

      def with_error_handle(action, conn, opts={}, &block)
        return block.call if opts[:handle_error] == false

        begin
          block.call
        rescue *bad_gateway_errors(action) => e
          run_bad_gateway_callbacks(action)
          reconnect(conn)
          raise Gateway::BadGateway.wrap(e)
        rescue *timeout_errors(action) => e
          run_timeout_callbacks(action)
          reconnect(conn)
          raise Gateway::GatewayTimeout.wrap(e)
        end
      end

      def bad_gateway_errors(action)
        raise "Abstract Method"
      end

      def timeout_errors(action)
        raise "Abstract Method"
      end

      def run_bad_gateway_callbacks(action)
        raise "Abstract Method"
      end

      def run_timeout_callbacks(action)
        raise "Abstract Method"
      end
    end
  end
end
