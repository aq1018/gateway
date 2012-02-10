module Gateway
  module Feature
    module NewRelic
      protected

      def with_new_relic(opts={}, &block)
        return block.call unless opts.fetch(:record_newrelic, record_newrelic)

        # per newrelic support: ['External/servicename/all', 'External/allWeb']
        metric_names = ["External/#{name}/all", 'External/allWeb']
        ::NewRelic::Agent::MethodTracer.trace_execution_scoped metric_names do
          block.call
        end
      end

      def record_newrelic
        defined?(::NewRelic) && options.fetch(:record_newrelic, false)
      end
    end
  end
end
