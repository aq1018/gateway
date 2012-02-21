require 'resource_pool'

module Gateway
  module Connection
    class Pool
      def initialize(gateway, options={})
        @gateway = gateway
        @options = options
      end

      def with_connection(&block)
        pool.hold do |conn|
          block.call(conn)
        end
      end

      def purge_current_connection!
        pool.trash_current!
      end

      protected

      def pool
        @pool ||= ResourcePool.new(options) { @gateway.connect }
      end

      def options
        {
          :delete_proc => lambda{ |conn| @gateway.disconnect conn }
        }.merge(@options)
      end
    end
  end
end
