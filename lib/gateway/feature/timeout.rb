module Gateway
  module Feature
    module Timeout
      DEFAULT_TIMEOUT = 2

      def timeout
        @timeout ||= options.fetch  :timeout,
                                    Gateway::Feature::Timeout::DEFAULT_TIMEOUT
      end

      protected

      def with_timeout(opts={}, &block)
        t = opts.fetch(:timeout, timeout)

        return block.call if t == false

        # if the timeout is 0 or negative, timeout is raised
        # without executing the block
        raise ::Timeout::Error if t <= 0

        ::Timeout.timeout(t){ block.call }
      end
    end
  end
end
