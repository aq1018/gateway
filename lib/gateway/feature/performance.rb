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

        start_time = Time.now

        begin
          resp = block.call
        ensure
          if e = $!
            status = error_status(e)
            desc   = error_message(e)
          else
            status = success_status(resp)
            desc   = success_message(resp)
          end

          duration = Time.now - start_time
          req = "#{action.to_s.upcase} #{req}"
          profiler.performance(name.to_s, duration, status, desc, req)
        end
      end

      def success_status(resp)
        200
      end

      def success_message(resp)
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
