module Gateway
  module Connection
    module Pool
      protected

      def with_pool(&block)
        pool.hold do |conn|
          block.call(conn)
        end
      end

      def purge_current_connection_from_pool!
        pool.trash_current!
      end

      def pool
        @pool ||= ResourcePool.new(pool_options) { connect }
      end

      def pool_options
        @pool_options ||= {
          :delete_proc => lambda{ |conn| disconnect conn }
        }.merge(options[:pool])
      end
    end
  end
end
