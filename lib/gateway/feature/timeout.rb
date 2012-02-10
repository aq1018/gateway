module Gateway
  module Feature
    module Timeout
      DEFAULT_TIMEOUT = 2

      def timeout
        @timeout ||= (options[:timeout] || Gateway::Feature::Timeout::DEFAULT_TIMEOUT)
      end

      protected

      def with_timeout(opts={}, &block)
        return block.call if opts[:timeout] == false
        ::Timeout.timeout(opts[:timeout] || timeout){ block.call }
      end
    end
  end
end
