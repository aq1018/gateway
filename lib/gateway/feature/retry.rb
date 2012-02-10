module Gateway
  module Feature
    module Retry
      protected

      def with_retry(action, opts={}, &block)
        return block.call unless opts.fetch(:retry, retry?)

        retried = false
        begin
          block.call
        rescue => e
          if !retried && retry_error?(action, e)
            run_retry_callbacks(action)
            retried = true
            retry
          end
          raise
        end
      end

      def retry_error?(action, error)
        error = error.inner_error if error.is_a?(Gateway::Error)
        errors = retry_errors(action)
        errors.any?{ |klass| error.is_a?(klass) }
      end

      def retry_errors(action)
        raise "Abstract Method"
      end

      def run_retry_callbacks(action)
        raise "Abstract Method"
      end

      def retry?
        @retry ||= options.fetch(:retry, true)
      end
    end
  end
end
