module Gateway
  class Base
    include Gateway::Feature::NewRelic
    include Gateway::Feature::Performance
    include Gateway::Feature::Timeout
    include Gateway::Feature::Retry
    include Gateway::Feature::ErrorHandle
    include Gateway::Feature::CategorizeError
    include Gateway::Connection

    categorize_error SystemCallError, SocketError, IOError,
                     :as => :bad_gateway

    categorize_error Timeout::Error,
                     :as => :timeout

    categorize_error SystemCallError, SocketError, IOError,
                     :as => :retry

    attr_reader :options, :name

    def initialize(name, opts)
      @name = name
      @options = opts
    end

    protected

    def bad_gateway_errors(action)
      errors_for(action, :bad_gateway)
    end

    def timeout_errors(action)
      errors_for(action, :timeout)
    end

    def retry_errors(action)
      errors_for(action, :retry)
    end

    def run_bad_gateway_callbacks(action)
      run_callbacks_for(action, :bad_gateway)
    end

    def run_timeout_callbacks(action)
      run_callbacks_for(action, :timeout)
    end

    def run_retry_callbacks(action)
      run_callbacks_for(action, :retry)
    end

    def execute(action, req, opts={}, &block)
      with_connection(opts) do |conn|
        with_retry(action, opts) do
          with_error_handle(action, conn, opts) do
            with_new_relic(opts) do
              with_perf(action, req, opts) do
                with_timeout(opts) do
                  block.call(conn)
                end
              end
            end
          end
        end
      end
    end
  end
end

