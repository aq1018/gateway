module Gateway
  module Feature
    module Performance
      def self.included(klass)
        klass.class_eval do
          class_attribute :profiler
        end if klass.is_a?(Class)
      end

      def profiler
        @profiler ||= (options[:profiler] || self.class.profiler)
      end

      protected

      def with_perf(action, req, opts={}, &block)
        return block.call if opts[:perf] == false

        status     = success_status
        desc       = success_message
        start_time = Time.now

        begin
          block.call
        rescue => e
          status = error_status(e)
          desc = error_message(e)
          raise
        ensure
          duration = Time.now - start_time
          req = "#{action.to_s.upcase} #{req}"
          profiler.performance(name.to_s, duration, status, desc, req)
        end
      end

      def success_status
        200
      end

      def success_message
        "OK"
      end

      def error_status(error)
        error.respond_to?(:status) ? error.status : 500
      end

      def error_message(error)
        "#{error.class.name} - #{error.message}"
      end
    end
  end
end
